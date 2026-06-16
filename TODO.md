# TODO

## Root cause investigation
- [ ] Verify ChatScreen loads messages from local storage instead of keeping an empty in-memory list.
- [ ] Verify ChatBloc emits states that the UI listens to (and that UI rebuilds from Bloc state, not local setState only).
- [ ] Verify UI is wired to ChatBloc instance (and provider config is loaded).

## Fix UI state handling
- [ ] Remove manual `_messages` in ChatScreen; use BlocBuilder/Bloc state to render message list.
- [ ] Add missing ChatBloc events/states to support loading messages for a conversation.
- [ ] Update ChatScreen to dispatch load event on `initState`.

## Fix AI request + loading logic
- [ ] Ensure `isWaitingForResponse` disables repeated requests in MessageComposer.
- [ ] Ensure ChatBloc does not emit ChatLoading only, but correct waiting state for typing indicator.
- [ ] Include conversation message history in AI request payload (not only last user message).

## Validation
- [ ] Run app, create conversation, send message, confirm assistant reply appears.
- [ ] Restart app, confirm conversations/messages persist.
- [ ] Test error handling (bad key/base URL / offline).

