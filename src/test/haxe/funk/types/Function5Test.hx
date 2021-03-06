package funk.types;

using Type;
using funk.types.Function5;
using funk.types.Tuple5;
using massive.munit.Assert;

class Function5Test {

    @Test
    public function when_calling__1__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value1;
        };
        a._1(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__2__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value2;
        };
        a._2(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__3__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value3;
        };
        a._3(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__4__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value4;
        };
        a._4(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling__5__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = value5;
        };
        a._5(true)(false, false, false, false);
        called.isTrue();
    }

    @Test
    public function when_calling_compose__should_call_function_and_return_correct_response() : Void {
        var a = function(value) {
            return value;
        };

        var b = a.compose(function(value1, value2, value3, value4, value5){
            return value1 || value2 || value3 || value4 || value5;
        })(false, true, false, false, false);

        b.isTrue();
    }

    @Test
    public function when_calling_map__should_call_function() : Void {
        var a = function(value1, value2, value3, value4, value5) {
            return value1 || value2 || value3 || value4 || value5;
        };

        var b = a.map(function(value){
            return !!value;
        })(false, true, false, false, false);

        b.isTrue();
    }

    @Test
    public function when_calling_curry__should_call_function() : Void {
        var called = false;
        var a = function(value1, value2, value3, value4, value5) {
            called = true;
            return value1 || value2 || value3 || value4 || value5;
        };
        a.curry()(false)(true)(false)(false)(false);
        called.isTrue();
    }

    @xTest
    public function when_calling_uncurry__should_call_function() : Void {
        var called = false;
        var a = function(value1) {
            return function(value2) {
                return function(value3) {
                    return function(value4) {
                        return function(value5) {
                            called = true;
                            return value4;    
                        }
                    }
                }
            }
        }.uncurry()(1, 2, 3, 4, 5);
        called.isTrue();
    }

    @Test
    public function when_calling_tuple__should_call_function() : Void {
        var a = function(value1, value2, value3, value4, value5) {
            return value1 || value2 || value3 || value4 || value5;
        }.untuple()(tuple5(false, true, false, false, false));
        a.isTrue();
    }

    @Test
    public function when_calling_untuple__should_call_function() : Void {
        var a = function(t : Tuple5<Bool, Bool, Bool, Bool, Bool>) {
            return t;
        }.tuple()(false, true, false, false, false);
        a.areEqual(tuple5(false, true, false, false, false));
    }

    @Test
    public function when_calling_lazy__should_return_value() : Void {
        var instance = Math.random();
        function(a, b, c, d, e) {
            return instance + a + b + c + d + e;
        }.lazy(1, 2, 3, 4, 5)().areEqual(instance + 1 + 2 + 3 + 4 + 5);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_value() : Void {
        var instance = Math.random();
        var lax = function(a, b, c, d, e) {
            return instance + a + b + c + d + e;
        };
        lax.lazy(1, 2, 3, 4, 5)();
        lax.lazy(1, 2, 3, 4, 5)().areEqual(instance + 1 + 2 + 3 + 4 + 5);
    }

    @Test
    public function when_calling_lazy_twice__should_return_same_instance() : Void {
        var lax = function(a, b, c, d, e) {
            return Math.random();
        }.lazy(1, 2, 3, 4, 5);
        lax().areEqual(lax());
    }

    @Test
    public function when_calling_lazy_twice__should_be_called_once() : Void {
        var amount = 0;
        var lax = function(a, b, c, d, e) {
            amount++;
            return {};
        }.lazy(1, 2, 3, 4, 5);
        lax();
        lax();
        amount.areEqual(1);
    }

    @Test
    public function when_effectOf_is_called_should_be_called_correctly() : Void {
        var called = false;
        var effect = function(a, b, c, d, e) {
            called = true;
            return 1;
        }.effectOf();
        effect(1, 2, 3, 4, 5);
        called.isTrue();
    }

    @Test
    public function when_swallowWith_is_called_should_return_func_value() : Void {
        var res = function(a, b, c, e, f) { return 1; }.swallowWith(2)(1, 2, 3, 4, 5);
        res.areEqual(1);
    }

    @Test
    public function when_swallowWith_is_called_should_return_default_value() : Void {
        var res = function(a, b, c, e, f) { throw "error"; return 1; }.swallowWith(2)(1, 2, 3, 4, 5);
        res.areEqual(2);
    }
}
