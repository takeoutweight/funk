class StringType extends Type<String> {
  
  String _value;
  
  StringType(){
  }
  
  String create(List args) {
    _value = args[0];
  }
  
  int hashCode() {
    return _value.hashCode();
  }
}
