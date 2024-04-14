# Server

I built a small demo server for Mangle how such an integration into a wider system could look.

The choice of tech is protobuf and grpc. These are straightforward (enough) to use, due to the 
availability of the protobuf compiler and supporting libraries.

Find the code here: https://github.com/burakemir/mangle-service

There are many ways in which this cannot be called a "real" database - but there
are also many ways in which is beats real database: serving from memory,
supporting expressive, recursive queries...

As far as proofs-of-concepts go, this little demo code also shows that the
interface to the Mangle library are clumsy and worth improving.

