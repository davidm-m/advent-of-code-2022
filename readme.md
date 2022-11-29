This is my attempt to solve all of Advent of Code 2022 using XQuery. Specifically, 1.0-ml with a MarkLogic database for
storing puzzle input and intermediate values.

While the MarkLogic instance is run in Docker, a lot of the setup and execution is manual and probably not best practice.
Please avoid using anything here in an actual application.

## Setup
Start by running `initialise-marklogic.sh`. This will spin up a docker container running a MarkLogic instance.
Instead of the default 8000, 8001 and 8002 ports, MarkLogic's ports will be available at 8030, 8031 and 8032. This is
solely to avoid this installation clashing with my normal development MarkLogic server.

The credentials are `admin:password`.

I recommend creating a database in the MarkLogic admin interface ([localhost:8031]) and attaching a forest to it. As we
aren't going to be doing any indexing or searching, all the default settings are fine.

Now go to the query console ([localhost:8030]), set the database to the one you just created, and the Query Type to XQuery.

## Running solutions
Each day normally has three parts: one to transform the puzzle input to some useful XML, one to solve the first part
of the day's puzzle, and one to solve the second. XQuery files for these are in each day's numbered folder. These files
are intended to be run directly through the query console.

## Development
While the query console has some hinting and autocompletion, it's a bit slow and not ideal for developing in. I use
IntelliJ with the "XQuery Support + MarkLogic Debugger" plugin, which provides support for 1.0-ml XQuery language features.