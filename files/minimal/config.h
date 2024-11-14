// files/minimal/quickjs-url.c
#include "quickjs.h"

static JSValue js_url_constructor(JSContext *ctx, JSValueConst new_target,
                                int argc, JSValueConst *argv)
{
    const char *url_str = JS_ToCString(ctx, argv[0]);
    if (!url_str)
        return JS_EXCEPTION;
    
    // Создаем простой объект URL с минимальными свойствами
    JSValue obj = JS_NewObjectClass(ctx, JS_CLASS_OBJECT);
    
    // Добавляем только необходимые свойства
    JS_DefinePropertyValueStr(ctx, obj, "href", 
                            JS_NewString(ctx, url_str), JS_PROP_C_W_E);
    
    JS_FreeCString(ctx, url_str);
    return obj;
}

static const JSCFunctionListEntry js_url_proto_funcs[] = {
    JS_CFUNC_DEF("constructor", 1, js_url_constructor),
};

void js_init_module_url(JSContext *ctx, JSModuleDef *m)
{
    JSValue proto, obj;
    
    // Создаем конструктор URL
    JS_NewClassID(&js_url_class_id);
    JS_NewClass(JS_GetRuntime(ctx), js_url_class_id, &js_url_class);
    
    proto = JS_NewObject(ctx);
    JS_SetPropertyFunctionList(ctx, proto, js_url_proto_funcs,
                             countof(js_url_proto_funcs));
    
    obj = JS_NewCFunction2(ctx, js_url_constructor, "URL", 1,
                          JS_CFUNC_constructor, 0);
    
    JS_SetConstructor(ctx, obj, proto);
    JS_SetClassProto(ctx, js_url_class_id, proto);
    
    JS_SetModuleExport(ctx, m, "URL", obj);
}

JSModuleDef *js_init_module_url(JSContext *ctx, const char *module_name)
{
    JSModuleDef *m;
    m = JS_NewCModule(ctx, module_name, js_init_module_url);
    if (!m)
        return NULL;
    JS_AddModuleExport(ctx, m, "URL");
    return m;
}