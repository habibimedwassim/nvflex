# Contributing to nvflux

Guidelines:
- Keep privileged code minimal and well-audited.
- Prefer small, focused commits and explain reasoning in commit messages.
- Add unit tests for parsing / pure logic. Tests should not require root.
- Use the provided CMake targets. Run tests with `ctest` from build directory.
- For packaging (deb/rpm/flatpak) leave setuid behavior to package scripts; installers can call scripts/install.sh.

Code style:
- Keep C idiomatic and portable. Avoid non-standard extensions unless necessary.
- Document edge cases and security rationale in code comments.

Submitting patches:
- Open an issue describing the change if non-trivial.
- Provide reproducer and test in `tests/` for logic changes.