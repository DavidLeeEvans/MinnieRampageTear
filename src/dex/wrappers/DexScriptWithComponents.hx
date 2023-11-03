package dex.wrappers;

import dex.wrappers.ScriptWithComponents.ScriptWithComponentsProperties;


@:autoBuild(dex.macro.DexScriptBuilder.build())
class DexScriptWithComponents<T: ScriptWithComponentsProperties> extends ScriptWithComponents<T>
{
}
