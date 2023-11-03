package dex.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.ComplexTypeTools;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;


typedef MsgHandlerFunc =
{
    var name: String;
    var msgHash: ExprDef;
    var func: Function;
};

class DexScriptBuilder
{
    public static function build(): Array<Field>
    {
        var fields: Array<Field> = Context.getBuildFields();

        var cls: ClassType = Context.getLocalClass().get();

        /**
         * Build the property accessors.
         */
        // disable this for now
        // genPropertyAccessors(cls, fields);

        /**
         * Build the message handlers.
         */
        var propsType: ComplexType = getScriptProperties(cls).propsType;

        var handlers: Array<MsgHandlerFunc> = getMessageHandlerFuncs(fields);
        var defaultHandlerName: String = getMessageDefaultHandlerName(fields);
        fields.push(createOnMessageMethod(propsType, handlers, defaultHandlerName));


        return fields;
    }

    static function genPropertyAccessors(cls: ClassType, fields: Array<Field>)
    {
        var props: AnonType = getScriptProperties(cls).props;

        // first create a field for the script's id
        fields.push(createHashField('_id_${cls.name}', '#${cls.name}'));

        for (prop in props.fields)
        {
            // create a field to hold the property hash
            fields.push(createHashField('_prop_${prop.name}', prop.name));

            // create a get/set field for the property
            fields.push(createPropertyField(prop.name, prop.type.toComplexType()));

            // create getter and setter
            fields.push(createGetter(cls.name, prop.name, prop.type.toComplexType()));
            fields.push(createSetter(cls.name, prop.name, prop.type.toComplexType()));
        }
    }

    static function getScriptProperties(cls: ClassType): {propsType: ComplexType, props: AnonType}
    {
        var props: AnonType = null;
        var propsType: ComplexType = null;
        switch cls.superClass.params[ 0 ]
        {
            case TType(t, _):
                {
                    switch t.get().type
                    {
                        case TAnonymous(fields):
                            {
                                propsType = t.get().type.toComplexType();
                                props = fields.get();
                            }

                        default:
                            {
                                Context.error('invalid type argument', Context.currentPos());
                            }
                    }
                }

            default:
                {
                    Context.error('invalid type argument', Context.currentPos());
                }
        }

        // filter out local properties
        props.fields = props.fields.filter(f -> f.meta.has('property'));

        return {
            propsType: propsType,
            props: props
        };
    }

    static function createHashField(name: String, value: String): Field
    {
        return {
            name: name,
            pos: Context.currentPos(),
            kind: FVar(TPath(
                {
                    pack: [ 'defold', 'types' ],
                    name: 'Hash'
                }), macro Defold.hash($v{value})),
            access: [ AStatic, APrivate, AFinal ],
            meta: [
                {name: ':noCompletion', pos: Context.currentPos()} ]
        }
    }

    static function createPropertyField(name: String, type: ComplexType): Field
    {
        return {
            name: name,
            pos: Context.currentPos(),
            kind: FProp('get', 'set', type),
            access: [ AStatic, APublic ]
        }
    }

    static function createGetter(clsName: String, propName: String, type: ComplexType): Field
    {
        return {
            name: 'get_$propName',
            pos: Context.currentPos(),
            kind: FFun(
                {
                    args: [ ],
                    ret: type,
                    expr: macro
                    {
                        return defold.Go.get($v{'_id_$clsName'}, $v{'_prop_$propName'});
                    }
                }),
            access: [ AStatic, AInline ],
            meta: [
                {name: ':noCompletion', pos: Context.currentPos()} ]
        }
    }

    static function createSetter(clsName: String, propName: String, type: ComplexType): Field
    {
        return {
            name: 'set_$propName',
            pos: Context.currentPos(),
            kind: FFun(
                {
                    args: [
                        {name: 'value', type: type} ],
                    ret: type,
                    expr: macro
                    {
                        defold.Go.set($v{'_id_$clsName'}, $v{'_prop_$propName'}, value);
                        return value;
                    }
                }),
            access: [ AStatic, AInline ],
            meta: [
                {name: ':noCompletion', pos: Context.currentPos()} ]
        }
    }

    /**
     * Gets all of the `Function` fields that have a `@msg` meta.
     *
     * @param fields
     */
    static function getMessageHandlerFuncs(fields: Array<Field>): Array<MsgHandlerFunc>
    {
        var funcs: Array<MsgHandlerFunc> = [ ];

        for (field in fields)
        {
            var msgHash: ExprDef = getMessageHandlerHash(field);
            if (msgHash == null)
            {
                // doesn't have a @msg meta
                continue;
            }

            switch field.kind
            {
                case FFun(f):
                    {
                        funcs.push(
                            {
                                name: field.name,
                                msgHash: msgHash,
                                func: f
                            });
                    }

                default:
                    {
                        Context.error('the @msg meta needs to be on functions', field.pos);
                    }
            }
        }

        return funcs;
    }

    static function getMessageHandlerHash(field: Field): ExprDef
    {
        if (field.meta == null)
        {
            return null;
        }
        for (meta in field.meta)
        {
            if (meta.name == 'msg')
            {
                if (meta.params.length > 1)
                {
                    Context.error(
                        'the @msg meta needs to have either one argument, which is the message hash; or no arguments for the catch-all handler',
                        field.pos
                    );
                }

                if (meta.params.length == 1)
                {
                    return meta.params[ 0 ].expr;
                }
            }
        }

        return null;
    }

    static function getMessageDefaultHandlerName(fields: Array<Field>): String
    {
        var defaultHandlerName: String = null;

        for (field in fields)
        {
            if (field.meta == null)
            {
                continue;
            }
            for (meta in field.meta)
            {
                if (meta.name != 'msg')
                {
                    continue;
                }

                // found @msg meta
                if (meta.params.length != 0)
                {
                    continue;
                }

                // found @msg meta with no arguments
                if (defaultHandlerName != null)
                {
                    Context.error('only one default message handler is allowed', field.pos);
                }

                defaultHandlerName = field.name;
            }
        }

        return defaultHandlerName;
    }

    static function createOnMessageMethod(propsType: ComplexType, handlerFuncs: Array<MsgHandlerFunc>, defaultHandlerName: String): Field
    {
        var casesCode: String = '';
        for (f in handlerFuncs)
        {
            var msgHash: String = null;
            switch f.msgHash
            {
                case EConst(c):
                    {
                        switch c
                        {
                            case CString(s):
                                {
                                    msgHash = s;
                                }

                            default:
                        }
                    }

                default:
            }

            var callArgs: Array<String> = [ ];
            for (arg in f.func.args)
            {
                if (arg.name == 'self')
                {
                    callArgs.push(arg.name);
                }
                else
                {
                    callArgs.push('message.${arg.name}');
                }
            }
            casesCode += 'case $msgHash: ${f.name}(${callArgs.join(', ')});\n';
        }

        // add default handler if it exists
        if (defaultHandlerName != null)
        {
            casesCode += 'default: $defaultHandlerName(self, message_id, message, sender);\n';
        }
        else
        {
            casesCode += 'default:\n';
        }

        var methodBody: String = '
        {
            super.on_message(self, message_id, message, sender);

            switch message_id {
                $casesCode
            }
        }
        ';


        return {
            name: 'on_message',
            access: [ AOverride ],
            pos: Context.currentPos(),
            meta: [
                {name: ':keep', pos: Context.currentPos()} ],
            kind: FFun(
                {
                    args: [
                        {
                            name: 'self',
                            type: propsType
                        },
                        {
                            name: 'message_id',
                            type: TPath({pack: [ 'defold', 'types' ], name: 'Message', params: [ TPType(macro : TMessage) ]})
                        },
                        {
                            name: 'message',
                            type: macro : TMessage
                        },
                        {
                            name: 'sender',
                            type: TPath({pack: [ 'defold', 'types' ], name: 'Url'})
                        }
                    ],
                    params: [
                        {name: 'TMessage'} ],
                    expr: Context.parse(methodBody, Context.currentPos()),
                })
        }
    }
}
#end
