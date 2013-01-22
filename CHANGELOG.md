# [0.6.2](https://github.com/siuying/NanoStoreInMotion/compare/v0.6.1%E2%80%A6v0.6.2)

- Revert to NanoStore 2.5.3

# [0.6.1](https://github.com/siuying/NanoStoreInMotion/compare/v0.6.0%E2%80%A6v0.6.1)

- ```attributes``` method to add multiple attributes in one line (thanks @gouravtiwari)
- Update for NanoStore 2.5.7

# [0.6.0](https://github.com/siuying/NanoStoreInMotion/compare/v0.5.2%E2%80%A6v0.6.0)

- Update for NanoStore 2.5.3, some notable changes:
  - accept nil and NSURL fields in model
  - can set store per instance

# [0.5.2](https://github.com/siuying/NanoStoreInMotion/compare/v0.5.1%E2%80%A6v0.5.2)

- Fix load error on older version of RubyMotion (or that disabled detect_dependencies)

# [0.5.1](https://github.com/siuying/NanoStoreInMotion/compare/v0.5.0%E2%80%A6v0.5.1)

- Update to NanoStore 2.1.6
- Convert predicate value to string, to fix type error that happen if attriutes are values other than string

# [0.5.0](https://github.com/siuying/NanoStoreInMotion/compare/v0.4.3%E2%80%A6v0.5.0)

- Add bag support in Model

# [0.4.3](https://github.com/siuying/NanoStoreInMotion/compare/v0.4.2%E2%80%A6v0.4.3)

- Fix bug saving bag to store

# [0.4.2](https://github.com/siuying/NanoStoreInMotion/compare/v0.4.1%E2%80%A6v0.4.2)

- Supports hashes with string keys in model initializer

# [0.4.1](https://github.com/siuying/NanoStoreInMotion/compare/v0.4.0%E2%80%A6v0.4.1)

- Fix bug when nil is inserted in field

# [0.4.0](https://github.com/siuying/NanoStoreInMotion/compare/v0.3.14%E2%80%A6v0.4.0)

- Use define_method in model instead of method_missing hacks (as rubymotion support define_method now)

# [0.3.13](https://github.com/siuying/NanoStoreInMotion/compare/v0.3.12%E2%80%A6v0.3.13)

- Add find_by_key
- Fix NameError when there's exception in store extension
- Update motion-cocoapods and bubble-wrap

# [0.3.12](https://github.com/siuying/NanoStoreInMotion/compare/v0.3.11%E2%80%A6v0.3.12)

- Update NanoStore pods to 2.1.4

# [0.3.0 - 0.3.11](https://github.com/siuying/NanoStoreInMotion/compare/v0.3.0%E2%80%A6v0.3.11)

- Fix crash on find_keys
- Fix finder
- Updated to NanoStore 2.1.3
- Add bulk delete
- Fix bug that #find and #all returning objects of any classes
- Add support array as parameter of finder (OR)
- Add sort to all finder
- Improved finder: now support specify multiple criteria with Array and Hash, as well as using hash for equality

# 0.2.3

- Initial gem release