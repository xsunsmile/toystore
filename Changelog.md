I will do my best to keep this up to date with significant changes here, starting in 0.8.3.

* 0.8.3 => 0.9.0
  * [Changed from `store` to `adapter`](https://github.com/jnunemaker/toystore/pull/1)
  * [Embedded objects were removed](https://github.com/jnunemaker/toystore/pull/2)
  * [Defaulted `adapter` to memory and removed `has_adapter?`](https://github.com/jnunemaker/toystore/commit/64268705fcb22d82eb7ac3e934508770ceb1f101)
  * [Introduced Toy::Object](https://github.com/jnunemaker/toystore/commit/f22fddff96b388db3bd22f36cc1cc29b28d0ae5e).
  * [Default Identity Map to off](https://github.com/jnunemaker/toystore/compare/02b652b4dbd4a652bf3d788fbf8cf7d0bae805f6...5cec60be60f9bf749964d5c2d437189287d6d837)
  * Removed several class methods related to identity map as well (identity_map_on/off/on?/off?/etc)