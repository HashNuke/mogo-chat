defmodule MogoChat.Router do
  use Phoenix.Router

  def start_link do
    __MODULE__.start
  end

  plug Plug.Parsers, parsers: [:urlencoded, :multipart, MogoChat.JsonParser]
  plug Plug.Static, at: "/static", from: :mogo_chat
  plug Plugs.Session, name: "mogo_chat_session", adapter: Plugs.Session.Adapters.Ets


  get  "/", MogoChat.Controllers.Main, :index, as: :index
  post "/tryout", MogoChat.Controllers.Main, :tryout

  get    "/api/sessions", MogoChat.Controllers.SessionsApi, :index
  post   "/api/sessions", MogoChat.Controllers.SessionsApi, :create
  delete "/api/sessions", MogoChat.Controllers.SessionsApi, :destroy


  get    "/api/users", MogoChat.Controllers.UsersApi, :index
  post   "/api/users", MogoChat.Controllers.UsersApi, :create
  get    "/api/users/:user_id", MogoChat.Controllers.UsersApi, :show
  put    "/api/users/:user_id", MogoChat.Controllers.UsersApi, :update
  delete "/api/users/:user_id", MogoChat.Controllers.UsersApi, :destroy


  get    "/api/rooms", MogoChat.Controllers.RoomsApi, :index
  post   "/api/rooms", MogoChat.Controllers.RoomsApi, :create
  get    "/api/rooms/:room_id", MogoChat.Controllers.RoomsApi, :show
  get    "/api/rooms/:room_id/users", MogoChat.Controllers.RoomsApi, :active_users
  put    "/api/rooms/:room_id", MogoChat.Controllers.RoomsApi, :update
  delete "/api/rooms/:room_id", MogoChat.Controllers.RoomsApi, :destroy


  get "/api/room_user_states", MogoChat.Controllers.RoomUserStatesApi, :show
  put "/api/room_user_states/:room_user_state_id", MogoChat.Controllers.RoomUserStatesApi, :update


  get  "/api/messages/:room_id", MogoChat.Controllers.MessagesApi, :index
  post "/api/messages", MogoChat.Controllers.MessagesApi, :create


  get "/rooms/:room_id/messages/:message_id", MogoChat.Controllers.RoomMessages, :show
end
