# API

[TODO: Too tired to complete the docs. If you feel like contributing, please take a look at the routers and send a pull-request.]

#### Roles

Valid roles are "admin" and "member".

#### Authentication

Find your auth token on your account settings page.
If your token is `1n2jjvsns`, pass the auth token as a header `Authorization: 1n2jjvsns` for the API request.

Using curl for example, to get a list of rooms,

```
curl -XGET http://example.com/api/rooms -H 'Authorization: 1n2jjvsns'
```

Your access to certain API calls depends on the role of your account.

#### Request body

Request body must be encoded in JSON for all POST and PUT requests.


### Available APIs

* [Users](#users)
  * [Create a user](#create-a-user)
  * [Modify a user](#modify-a-user)
  * [Delete a user](#delete-a-user)
* [Rooms](#rooms)
  * [Create a room](#create-a-room)
  * [Modify a room](#modify-a-room)
  * [Delete a room](#delete-a-room)
  * [Active users in a room](#active-users-in-a-room)
* [Messages](#messages)
  * [Post a message to a room](#post-a-message-to-a-room)
  * [Get messages in a room](#get-messages-in-a-room)
* [Room User States](#room-user-states)
  * [Get room states](#get-room-states)
  * [Join or leave rooms](#join-or-leave-rooms)
* [Sessions](#sessions)
  * [Sign in](#sign-in)


## Users

#### Create a user

> POST /api/users

Request body example:

```
{
  "user": {
    "name": "John Doe",
    "email": "user@example.com",
    "password": "password",
    "role": "member"
  }
}
```

#### Modify a user

> PUT /api/users/:user_id

```
{
  "user": {
    "name": "John Doe",
    "email": "user@example.com",
    "password": "password",
    "role": "member"
  }
}
```

#### Delete a user

> DELETE /api/users/:user_id


## Rooms

#### Create a room

> POST /api/rooms

```
{
  "room": {
    name: "Example"
  }
}
```

#### Modify a room

> PUT /api/rooms/:room_id

```
{
  "room": {
    name: "New room name"
  }
}
```

#### Delete a room

> DELETE /api/users/:room_id


#### Active users in a room

> GET /rooms/:room_id/users

You must be active in a room ("joined") to access it's user list.

```
TODO example body
```

## Messages

#### Post a message to a room

> POST /messages

Request body:

```
{
  "message": {
    "room_id": 1,
    "user_id": 2,
    "body": "Hey guys, what's up?",
    "type": "text"
  }
}
```

Response body:
```
{
  "message": {
    "id": 80,
      "room_id": 1,
      "user_id": 2,
      "body": "Hey guys, what's up?",
      "type": "text",
      "created_at": "2014-04-07T08:28:48Z"
  }
}
```

#### Get messages in a room

> GET /messages/:room_id

By default lists the most recent 20 messages in a room.

In order to get a room's history or get future messages, you can pass any one of the following params:

* `before` - ID of a message, before which you need the 20 previous (older) messages. Use this to fetch history.
* `after` - ID of a message, after which you need the next (newer) 20 messages. Use this to poll for new messages.

```
TODO
```

## Room User States

#### Get room states

> GET /api/room_user_states

Returns the user's states of rooms (joined/unjoined, last pinged at, etc), along with the room details (only name of the room for now).

```
TODO
```

#### Join or leave rooms

> PUT /api/room_user_states/:room_user_state_id

The `room_user_state_id` is the user's state's ID in a room.
It is not the room ID. The user's states for rooms can be fetched as mentioned in the previous request

Set `joined` to `true` to join a room, or set `false` to leave it.

```
TODO
```

## Sessions

#### Sign in
> POST /api/sessions

Request body:

```
{
  "email": "you@example.com",
    "password": "correct horse battery staple"
}
```

Response body:

```
{
  "user": {
    "id": 1,
      "name": "You",
      "role": "admin",
      "email": "you@example.com",
      "auth_token": "aa23e8a5-c9d1-4656-bee0-e30807177e0d"
  }
}
```
