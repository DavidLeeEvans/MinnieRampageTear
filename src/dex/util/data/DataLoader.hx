package dex.util.data;

#if macro
import sys.io.File;

import haxe.macro.Context;
import haxe.macro.Type.ClassType;
import haxe.macro.Type.ClassField;
import haxe.macro.Expr;

using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

class DataLoader {
	public static var pos(get, never):Position;

	inline static function get_pos():Position {
		return Context.currentPos();
	}

	public static function buildIdEnum(path:String):Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();

		var file = File.read(path, false);

		while (!file.eof()) {
			var line:String = file.readLine();

			var itemId:String = line.split(',')[0];

			fields.push({
				name: itemId,
				kind: FVar(null),
				pos: pos,
			});
		}

		return fields;
	}

	public static function buildDataStore():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();

		for (field in fields) {
			var dsField:DatastoreFieldRetValue = getDatastoreFilePathFromTypeMetadata(field);
			if (dsField == null) {
				continue;
			}

			var typeFields:Array<ClassField> = getAnonymousTypeFields(field);

			var dataExpr:Array<Expr> = [];

			var file = File.read(dsField.filePath, false);
			while (!file.eof()) {
				var line:String = file.readLine();

				var objectFields:Array<ObjectField> = unpackLineToFieldsExpr(typeFields, line);

				switch dsField.varType {
					case Array:
						{
							dataExpr.push({
								expr: EObjectDecl(objectFields),
								pos: pos,
							});
						}
					case Map:
						{
							var idExpr:Expr;
							for (objField in objectFields) {
								if (objField.field == "id") {
									idExpr = objField.expr;
									break;
								}
							}

							if (idExpr == null) {
								throw 'datastore variables can be maps only if they define a field called "id", with the type of a built enum';
							}

							dataExpr.push({
								expr: EBinop(OpArrow, idExpr, {
									expr: EObjectDecl(objectFields),
									pos: pos,
								}),
								pos: pos,
							});
						}
					default:
				}
			}

			var arr:Expr = {
				expr: EArrayDecl(dataExpr),
				pos: pos,
			};

			field.kind = FVar(getFieldType(field), arr);
		}

		return fields;
	}

	static function getDatastoreFilePathFromTypeMetadata(field:Field):DatastoreFieldRetValue {
		switch field.kind {
			case FVar(t, e):
				{
					var varType:DatastoreVarTypeRetValue = getDatastoreVarType(t);
					if (varType == null) {
						return null;
					}

					var paramIdx:Int = -1;
					if (varType.varType == Array) {
						paramIdx = 0;
					} else if (varType.varType == Map) {
						paramIdx = 1;
					} else {
						return null;
					}
					switch varType.params[paramIdx] {
						case TType(t, params):
							{
								if (t.get().meta.has("datastore")) {
									var metadata:MetadataEntry = t.get().meta.extract("datastore")[0];
									switch metadata.params[0].expr {
										case EConst(c):
											{
												switch c {
													case CString(s, kind):
														{
															return {
																filePath: s,
																varType: varType.varType,
															};
														}
													default:
												}
											}
										default:
									}
								}
							}
						default:
					}
				}
			default:
		}

		return null;
	}

	static function getAnonymousTypeFields(field:Field):Array<ClassField> {
		switch field.kind {
			case FVar(t, e):
				{
					var varType:DatastoreVarTypeRetValue = getDatastoreVarType(t);
					if (varType == null) {
						return null;
					}

					var paramIdx:Int = -1;
					if (varType.varType == Array) {
						paramIdx = 0;
					} else if (varType.varType == Map) {
						paramIdx = 1;
					} else {
						return null;
					}

					switch varType.params[paramIdx] {
						case TType(t, params):
							{
								switch t.get().type {
									case TAnonymous(a):
										{
											return a.get().fields;
										}
									default:
								}
							}
						default:
					}
				}
			default:
		}

		return null;
	}

	static function getFieldType(field:Field):ComplexType {
		switch field.kind {
			case FVar(t, e):
				{
					return t;
				}
			default:
		}
		return null;
	}

	static function unpackLineToFieldsExpr(typeFields:Array<ClassField>, line:String):Array<ObjectField> {
		var parts:Array<String> = line.split(',');
		if (typeFields.length != parts.length) {
			throw 'inconsistent type with datastore: $typeFields';
		}

		var objectFields:Array<ObjectField> = [];

		for (i in 0...typeFields.length) {
			var fieldDatastoreColumn:Int = typeFields[i].meta.extract("column")[0].params[0].getValue();
			var fieldDatastoreValue:String = parts[fieldDatastoreColumn];

			var objectFieldExpr:ExprDef;

			switch typeFields[i].type.follow() {
				case TInst(t, params) if (t.get().name == "String"):
					{
						objectFieldExpr = EConst(CString(fieldDatastoreValue));
					}
				case TAbstract(t, params) if (t.get().name == "Int"):
					{
						objectFieldExpr = EConst(CInt(fieldDatastoreValue));
					}
				case TAbstract(t, params) if (t.get().name == "Float"):
					{
						objectFieldExpr = EConst(CFloat(fieldDatastoreValue));
					}
				case TInst(t, params) if (t.get().name == "Hash"):
					{
						objectFieldExpr = ECall(macro Defold.hash, [{expr: EConst(CString(fieldDatastoreValue)), pos: pos}]);
					}
				default:
					{
						objectFieldExpr = EConst(CIdent(fieldDatastoreValue));
					}
			}

			objectFields.push({
				field: typeFields[i].name,
				expr: {
					expr: objectFieldExpr,
					pos: pos,
				}
			});
		}

		return objectFields;
	}

	static function getDatastoreVarType(ct:ComplexType):DatastoreVarTypeRetValue {
		switch ct.toType() {
			case TInst(t, params):
				{
					if (t.get().name == "Array") {
						return {
							varType: Array,
							params: params,
						};
					}
				}

			case TType(t, params):
				{
					if (t.get().name == "Map") {
						return {
							varType: Map,
							params: params,
						};
					}
				}

			default:
		}

		return null;
	}
}

enum DatastoreVarType {
	Array;
	Map;
}

typedef DatastoreVarTypeRetValue = {
	var varType:DatastoreVarType;

	var params:Array<haxe.macro.Type>;
}

typedef DatastoreFieldRetValue = {
	var filePath:String;

	var varType:DatastoreVarType;
}
#end
