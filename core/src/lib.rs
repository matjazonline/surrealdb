#[macro_use]
extern crate tracing;

#[macro_use]
mod mac;

mod cf;
mod ctx;
mod doc;
mod exe;
mod fnc;
mod vs;

pub mod sql;

#[doc(hidden)]
pub mod cnf;
#[doc(hidden)]
pub mod dbs;
#[doc(hidden)]
pub mod env;
#[doc(hidden)]
pub mod err;
#[doc(hidden)]
pub mod iam;
#[doc(hidden)]
pub mod idg;
#[doc(hidden)]
pub mod idx;
#[doc(hidden)]
pub mod key;
#[doc(hidden)]
pub mod kvs;

#[cfg(feature = "ml")]
#[doc(hidden)]
pub mod obs;
#[doc(hidden)]
pub mod syn;

#[doc(hidden)]
/// Channels for receiving a SurrealQL database export
pub mod channel {
	pub use channel::bounded;
	pub use channel::unbounded;
	pub use channel::Receiver;
	pub use channel::Sender;
}
