App.RoomUserStateSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    room: {embedded: "load"},
    user: {embedded: "load"}
  }
})


App.MessageSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    user: {embedded: "load"}
  }
})
