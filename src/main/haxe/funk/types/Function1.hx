package funk.types;

import funk.reactives.Process;

using funk.types.Function0;
using funk.types.Option;
using funk.types.Tuple1;

typedef Function1<T1, R> = T1 -> R;
typedef Dispatcher1<T1, R> = {
    function dispatch(value0 : T1) : R;
}
typedef Executioner1<T1, R> = {
    function execute(value0 : T1) : R;
}


class Function1Types {

    public static function _1<T1, R>(func : Function1<T1, R>, value1 : T1) : Function0<R> {
        return function() return func(value1);
    }

    public static function indentity<T>() : Function1<T, T> return function(x) return x;

    public static function compose<T1, T2, R>(from : Function1<T2, R>, to : Function1<T1, T2>) : Function1<T1, R> {
        return function(value0 : T1) return from(to(value0));
    }

    public static function map<T1, T2, R>(func : Function1<T1, T2>, mapper : Function1<T2, R>) : Function1<T1, R> {
        return function(value0 : T1) return mapper(func(value0));
    }

    public static function curry<T1, T2>(func : Function1<T1, T2>) : Function1<T1, T2> return func;

    public static function uncurry<T1, R>(func : Function1<T1, Function0<R>>) : Function1<T1, R> {
        return function(value0 : T1) : R return func(value0)();
    }

    public static function untuple<T1, R>(func : Function1<T1, R>) : Function1<Tuple1<T1>, R> {
        return function(tuple : Tuple1<T1>) return func(tuple._1());
    }

    public static function tuple<T1, R>(func : Function1<Tuple1<T1>, R>) : Function1<T1, R> {
        return function(value0) return func(tuple1(value0));
    }

    public static function lazy<T1, R>(func : Function1<T1, R>, value0 : T1) : Function0<R> {
        var value : R = null;
        return function() return (value == null) ? value = func(value0) : value;
    }

    public static function effectOf<T1, R>(func : Function1<T1, R>) : Function1<T1, Void> {
        return function(value0 : T1) func(value0);
    }

    public static function swallowWith<T1, R>(func : Function1<T1, R>, res : R) : Function1<T1, R> {
        return function(a) return try func(a) catch (e : Dynamic) res; 
    }

    public static function trampoline<T1>(func : Function1<T1, Void>, ?bounce : Int = 0) : Function1<T1, Void> {
        return function(value0 : T1) : Void {
            if (bounce < 1) func(value0);
            else Process.start(function() : Void func(value0), bounce);
        };
    }
}
