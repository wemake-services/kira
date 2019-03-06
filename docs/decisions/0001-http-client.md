# Choosing HTTP Client

Author: @sobolevn
Date: 10.02.2019


## Decision

We are going to use [`Tesla`](https://github.com/teamon/tesla)
client with `hackney` as an adapter.


## Reasoning

It suit all the criteria we have:

1. Testable: it is shipped with `Mock` adapter to be used with tests
2. Secure: `hackney` allows us [not to care about `https` certificates](https://blog.voltone.net/post/7) while other adapters uses insecure `https` defaults
3. Reliable: retries are shipped as a custom middleware

I also personally like the way it allows to write declarative API.
