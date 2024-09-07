{
  system,
  nixago,
}:
config: {
  format = "text";
  output = ".vagrant/${config.name}";

  data = {
    data = {
      inherit config;
    };
  };

  engine = nixago.engines."${system}".cue {
    flags = {
      expression = "rendered";
      out = "text";
    };
    files = [ ./template.cue ];
  };
}
