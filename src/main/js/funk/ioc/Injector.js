funk.ioc = funk.ioc || {};
funk.ioc.Injector = (function(){
    "use strict";
    var lock = true;
    var injector = null;
    var InjectorImpl = function(){
        if(lock){
            funk.util.isAbstract();
        } else {
            this._map = {};
            this._scopes = funk.collection.immutable.nil();
            this._modules = funk.collection.immutable.nil();
            this._currentScope = null;
        }
    };
    InjectorImpl.prototype = {};
    InjectorImpl.prototype.constructor = InjectorImpl;
    InjectorImpl.prototype.name = "Injector";
    InjectorImpl.initialize = function(module){
        if(module === funk.util.verifiedType(module, funk.ioc.Module)){
            module.initialize();
            injector._modules = injector._modules.prepend(module);
        }
        return module;
    };
    InjectorImpl.pushScope = function(module){
        if(module === funk.util.verifiedType(module, funk.ioc.Module)){
            injector._currentScope = module;
            injector._scopes = injector._scopes.prepend(module);
        }
    };
    InjectorImpl.pushScope = function(module){
        if(module === funk.util.verifiedType(module, funk.ioc.Module)){
            injector._scopes = injector._scopes.tail();
            if(injector._scopes.nonEmpty()) {
                // TODO (Simon) Make injector._currentScope none or some.
                var head = injector._scopes.head();
                injector._currentScope = funk.option.when(head, {
                        none: function(){
                            return null;
                        },
                        some: function(){
                            return funk.util.verifiedType(head, funk.ioc.Module);
                        }
                    }
                );
            } else {
                injector._currentScope = null;
            }
        }
    };
    InjectorImpl.currentScope = function(){
        return injector._currentScope;
    };
    InjectorImpl.scopeOf = function(value){
        var result = null;
        var module = null;
        var modules = injector._modules;

        while(modules.nonEmpty()) {
            module = modules.head();

            if(module.binds(value)) {
                if(null != result) {
                    throw new funk.error.BindingError("More than one module binds " + value + ".")
                }
                result = module;
            }

            modules = modules.tail();
        }

        if(null == result) {
            throw new funk.error.BindingError("No binding for " + value + " could be fond.")
        }

        return result;
    };
    InjectorImpl.moduleOf = function(value){
        var possibleResult = injector._map[value];

        if(null != possibleResult) {
            return possibleResult;
        }

        var module = null;
        var modules = injector._modules;

        while(modules.nonEmpty()) {
            module = modules.head();

            if(module instanceof value) {
                injector._map[value] = module;
                return module;
            }

            modules = modules.tail();
        }

        throw new funk.error.BindingError("No module for " + value + " could be found.")
    }
    // Create a new instance
    lock = false;
    injector = new InjectorImpl();
    lock = true;
    // Return the injector
    return InjectorImpl;
})();