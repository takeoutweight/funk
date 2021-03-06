package funk.types;

import funk.types.Attempt;
import funk.types.Either;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Option;
import funk.types.Attempt;
import funk.types.Wildcard;
import funk.types.extensions.Strings;

typedef Any<T> = T;
typedef AnyRef = Dynamic;

class AnyTypes {

    public static function equals<T1, T2>(value0 : T1, value1 : T2, ?func : Predicate2<T1, T2>) : Bool {
        if (func == null) {
            func = function(a, b) {
                var type0 = Type.typeof(a);
                var type1 = Type.typeof(b);
                if (Type.enumEq(type0, type1)) {
                    return switch(type0) {
                        case TEnum(_): Type.enumEq(cast a, cast b);
                        case _: cast a == cast b;
                    }
                }
                return false;
            };
        }
        return func(value0, value1);
    }

    public static function getName<T>(value : T)  : String {
        return switch(Type.typeof(value)) {
            case TUnknown: 'unknown';
            case TObject: try Type.getClassName(cast value) catch(e:Dynamic) Std.string(value);
            case TNull: 'null';
            case TInt: 'int';
            case TFunction: 'function';
            case TFloat: 'float';
            case TEnum(e): '${Type.getEnumName(e)}.${Type.enumConstructor(cast value)}';
            case TClass(e): Type.getClassName(e);
            case TBool: 'bool';
        }
    }

    public static function getSimpleName<T>(value : T)  : String {
        function extract(name : String) {
            var runtimeIndexName = name.indexOf('{');
            return if (runtimeIndexName >= 0) 'Unknown';
            else name.substr(name.lastIndexOf(".") + 1);
        }

        var name = getName(value);
        return switch (Type.typeof(value)) {
            case TObject: extract(name);
            case TClass(_): extract(name);
            case _: name;
        }
    }

    public static function getClass<T>(value : T) : Class<T> return Type.getClass(value);

    inline public static function isTypeOf<T>(value : T, possible : String) : Bool {
        var value = switch(Type.typeof(value)) {
            case TUnknown: 'unknown';
            case TObject: 'object';
            case TNull: 'null';
            case TInt: 'int';
            case TFunction: 'function';
            case TFloat: 'float';
            case TEnum(_): 'enum';
            case TClass(_): 'class';
            case TBool: 'bool';
        }
        return value == possible;
    }

    public static function isObject<T>(value : T) : Bool return isTypeOf(value, 'object');

    public static function isNull<T>(value : T) : Bool return isTypeOf(value, 'null');

    public static function isInt<T>(value : T) : Bool return isTypeOf(value, 'int');

    public static function isFunction<T>(value : T) : Bool return isTypeOf(value, 'function');

    public static function isFloat<T>(value : T) : Bool return isTypeOf(value, 'int');

    public static function isEnum<T>(value : T) : Bool return isTypeOf(value, 'enum');

    public static function isClass<T>(value : T) : Bool return isTypeOf(value, 'class');

    public static function isBoolean<T>(value : T) : Bool return isTypeOf(value, 'bool');

    public static function asInstanceOf<T : AnyRef, R>(value : T, possible : Class<R>) : R {
        // Runtime cast, rather than a compile type cast.
        return isInstanceOf(value, possible) ? cast value : throw 'Cannot cast $value to $possible';
    }

    inline public static function isInstanceOf<T : AnyRef>(value : T, possible : AnyRef) : Bool {
        return Std.is(value, possible);
    }

    public static function isValueOf<T : AnyRef>(value : T, possible : AnyRef) : Bool {
        return if (value == null || possible == null) false;
        else switch(Type.typeof(value)) {
            case TEnum(_) if(isInstanceOf(possible, Enum)): Type.getEnum(value) == possible;
            case TEnum(_) if(isEnum(possible) && Type.enumEq(value, possible)): true;
            case _: equals(value, possible);
        }
    }

    public static function toBool<T>(value : Null<T>) : Bool {
        return if(value == null) false;
        else if(isInstanceOf(value, Bool)) cast value;
        else if(isInstanceOf(value, Float) || isInstanceOf(value, Int)) cast(value) > 0;
        else if(isInstanceOf(value, String)) Strings.isNonEmpty(cast value);
        else if(isInstanceOf(value, Option)) OptionTypes.toBool(cast value);
        else if(isInstanceOf(value, Attempt)) AttemptTypes.toBool(cast value);
        else if(isInstanceOf(value, Either)) EitherTypes.toBool(cast value);
        else true;
    }

    public static function toString<T>(value : T, ?func : Function1<T, String>) : String {
        // NOTE (Simon) : Workout if the value has a toString method
        return if(toBool(func)) func(value);
        else Std.string(value);
    }
}
