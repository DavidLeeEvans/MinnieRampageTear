package dex.util;

import defold.Sys;
import haxe.CallStack;
import haxe.PosInfos;


class DexError
{
    /**
     * Raises an error and exist the application if a given condition is evaluated as `false`.
     *
     * @param cond the boolean condition to check; if `false` the error is raised
     * @param msg optional message to print to the output if the assertion fails
     */
    public static inline function assert(cond: Bool, ?msg: String, ?pos: PosInfos)
    {
        if (!cond)
        {
            error(msg != null ? msg : "assert failed", pos);
        }
    }

    /**
     * Prints a warning message to the output if the assertion fails.
     *
     * This will **not** terminate the application or the current function.
     *
     * @param cond the boolean condition to check; if `false` the warning is printed
     * @param msg optional message to print to the output if the assertion fails
     */
    public static inline function assertWarn(cond: Bool, ?msg: String, ?pos: PosInfos)
    {
        if (!cond)
        {
            warn(msg != null ? msg : "assert failed", pos);
        }
    }

    /**
     * Raises a lua error and exits the application.
     *
     * @param msg optional message to print to the output
     */
    public static function error(?msg: String, ?pos: PosInfos): Dynamic
    {
        Lua.error('$msg\n${pos.fileName}:${pos.lineNumber}\n${CallStack.toString(CallStack.callStack())}');
        Sys.exit(1);

        // an arbitrary return is used so that the compiler allows us to call this
        // from return-switch combos
        return null;
    }

    /**
     * Prints a warning message to the output.
     *
     * @param msg optional message to print to the output
     */
    public static function warn(?msg: String, ?pos: PosInfos)
    {
        Sys.println('WARN: ${pos.fileName}:${pos.lineNumber} $msg');
        Sys.println(CallStack.toString(CallStack.callStack()));
    }
}
