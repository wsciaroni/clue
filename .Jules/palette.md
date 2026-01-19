## 2024-05-22 - Input Validation & Memory Management in Forms
**Learning:** Dynamic lists of controllers (like in `SetupScreen`) are easy to leak if not explicitly disposed. Also, mismatch between declared quantity and actual selection (card count) requires inline or pre-submit validation to prevent user frustration.
**Action:** Always check for `dispose` when `TextEditingController`s are used, especially in dynamic lists. Ensure numerical inputs that dictate other selection limits (like "how many cards") are cross-validated.
