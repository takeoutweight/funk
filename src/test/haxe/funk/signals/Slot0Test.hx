package funk.signals;

import funk.signals.Signal0;

using funk.types.Option;
using funk.types.PartialFunction0;
using massive.munit.Assert;
using unit.Asserts;

class Slot0Test {

    public var signal : Signal0;

    @Before
    public function setup() {
        signal = new Signal0();
    }

    @After
    public function tearDown() {
        signal = null;
    }

    @Test
    public function when_calling_execute__should_call_listener() : Void {
        var called = false;
        var listener = function() {
            called = true;
        }.fromFunction();
        var slot = new Slot0(signal, listener, false);
        slot.execute();
        called.isTrue();
    }

    @Test
    public function when_calling_execute__should_leave_signal_with_one() : Void {
        var listener = function() {}.fromFunction();
        var slot = signal.add(listener).get();
        slot.execute();
        signal.size().areEqual(1);
    }

    @Test
    public function when_calling_execute_with_once__should_leave_signal_with_zero() : Void {
        var listener = function() {}.fromFunction();
        var slot = signal.addOnce(listener).get();
        slot.execute();
        signal.size().areEqual(0);
    }

    @Test
    public function when_calling_remove_twice__should_signal_with_zero_listeners() : Void {
        var listener = function() {}.fromFunction();
        var slot = signal.add(listener).get();
        slot.remove();
        slot.remove();
        signal.size().areEqual(0);
    }

    @Test
    public function when_calling_listener__should_return_same_listener() : Void {
        var listener = function() {}.fromFunction();
        var slot = new Slot0(signal, listener, false);
        slot.listener().areEqual(listener);
    }
}
