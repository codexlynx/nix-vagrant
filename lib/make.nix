{
  system,
  nixago,
}:
# TODO: Validate and documentate config
path: config:
(nixago.lib."${system}".make {
  format = "text";
  output = path;

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
})
