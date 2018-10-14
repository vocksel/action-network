return {
    -- Name of the RemoteEvent. Must be something unique so the client can find
    -- it later.
    REMOTE_NAME = "ActionDispatchRemote";

    -- Location where the RemoteEvent is stored.
    REMOTE_STORAGE = game.ReplicatedStorage;

    -- How long (in seconds) to wait on the client before assuming the
    -- RemoteEvent isn't going to exist. This gives us a chance to error out,
    -- as something is likely wrong.
    WAIT_FOR_REMOTE_TIMEOUT = 5;
}
