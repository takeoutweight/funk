package funk.actors;

import funk.actors.ActorSystem;

using funk.actors.ActorCell;
using funk.actors.ActorSystem;
using funk.futures.Promise;
using funk.types.Option;
using funk.collections.immutable.List;

class ActorRef {

    private var _actorCell : ActorCell;

    private var _actorContext : ActorContext;

    public function new() {
        _actorCell = new ActorCell(_system, this, _props);
        _actorContext = _actorCell;
    }

    public function ask(reciever : ActorRef, message : EnumValue) : Promise<EnumValue> {
        return null;
    }

    public function path() : ActorPath {
        return null;
    }

    public function forward(message : EnumValue) : Void {

    }

    public function tell(message : EnumValue, sender : ActorRef) : Void {
        // var ref = AnyTypes.toBool(sender) ? sender : system.deadLetters;
        // dispatcher.dispatch(this, Envelope(message, s)(system))
    }

    public function suspended() : Void _actorCell.suspended();

    public function resume() : Void _actorCell.resume();

    public function stop() : Void _actorCell.stop();

    public function parent() : ActorRef return _actorCell.parent();

    public function provider() return _actorCell.provider();

    public function system() : ActorSystem return _actorCell.system();

    public function getChild(names : List<String>) : ActorRef {
        function rec(ref : ActorRef, name : List<String>) : ActorRef {
            return switch(ref) {
                case _ if(Std.is(ref, InternalActorRef)):
                    var n = names.head();
                    var next = switch(n) {
                        case "..": ref.parent().toOption();
                        case "": Some(ref);
                        case _: ref.getSingleChild(n).toOption();
                    }
                    if (next.isDefined() || name.isEmpty()) next;
                    else rec(next, name.tail());
                case _: ref.getChild(name);
            }
        }

        return if (names.isEmpty()) this;
        else rec(this, names);
    }

    private function getSingleChild(name : String) : Option<InternalActorRef> {
        _actorCell.childrenRefs.filter(function(value) {
            return value.name() == name;
        });
    }
}

class LocalActorRef extends InternalActorRef {

    private var _system : ActorSystem;

    private var _props : Props;

    private var _supervisor : InternalActorRef;

    public function new(system : ActorSystem, props : Props, supervisor : InternalActorRef) {
        super();

        _system = system;
        _props = props;
        _supervisor = supervisor;
    }

    public function cell() : ActorCell return _actorCell;
}
