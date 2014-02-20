DS.ArrayTransform = DS.Transform.extend
  deserialize: (serialized)-> []
  serialize: (deserialized)-> []

App.register("transform:array", DS.ArrayTransform)
