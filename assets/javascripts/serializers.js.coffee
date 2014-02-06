App.RoomUserStateSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    room: {embedded: "load"}
  }
})


App.MessageSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    user: {embedded: "load"}
  }
})
