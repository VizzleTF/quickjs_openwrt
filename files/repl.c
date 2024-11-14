#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "quickjs-libc.h"

#define PROG_NAME "qjs"

static int eval_buf(JSContext *ctx, const void *buf, int buf_len,
                   const char *filename, int eval_flags)
{
    JSValue val;
    int ret;

    if ((eval_flags & JS_EVAL_TYPE_MASK) == JS_EVAL_TYPE_MODULE) {
        val = JS_Eval(ctx, buf, buf_len, filename,
                     eval_flags | JS_EVAL_FLAG_COMPILE_ONLY);
        if (!JS_IsException(val)) {
            js_module_set_import_meta(ctx, val, TRUE, TRUE);
            val = JS_EvalFunction(ctx, val);
        }
    } else {
        val = JS_Eval(ctx, buf, buf_len, filename, eval_flags);
    }
    if (JS_IsException(val)) {
        js_std_dump_error(ctx);
        ret = -1;
    } else {
        ret = 0;
    }
    JS_FreeValue(ctx, val);
    return ret;
}

static JSContext *JS_NewCustomContext(JSRuntime *rt)
{
    JSContext *ctx = JS_NewContext(rt);
    if (!ctx)
        return NULL;
    return ctx;
}

int main(int argc, char **argv)
{
    JSRuntime *rt;
    JSContext *ctx;
    int ret;

    rt = JS_NewRuntime();
    if (!rt) {
        fprintf(stderr, "qjs: cannot allocate JS runtime\n");
        exit(2);
    }
    ctx = JS_NewCustomContext(rt);
    if (!ctx) {
        fprintf(stderr, "qjs: cannot allocate JS context\n");
        exit(2);
    }

    /* system modules */
    js_init_module_std(ctx, "std");
    js_init_module_os(ctx, "os");

    ret = eval_buf(ctx, "print('Hello from QuickJS!')", 28, "<input>", 0);

    JS_FreeContext(ctx);
    JS_FreeRuntime(rt);
    return ret;
}