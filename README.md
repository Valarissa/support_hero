## README

This application runs using Ruby 2.3.0 and is reliant upon PostgreSQL

The easiest way to get up and running in the author's opinion is to utilize
Homebrew to install Ruby and PostgreSQL respectively. If you aren't using a
Mac, then you can utilize whatever package manager you choose for whatever
flavor of Linux you're running instead of Homebrew.

Homebrew installation instructions can be found at: http://brew.sh/
Or, just run `ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"`
after installing ruby.
Once Homebrew is installed, you can simply use `brew install postgresql` to get the
latest PostgreSQL installation up and running.

After these are installed, feel free to use git to clone the repository.
If you don't have git installed, use a package manager or Homebrew to get it.

After cloning, hop into the home directory (if you're using RVM, you'll be
prompted to trust the .rvmrc file). From there you'll want to do the following:

* Run `bin/setup`

This command will install bundler, run `bundle install`, create and migrate
the databases, including app default setup, and then helpfully run tests and start
the server.

All tests should be green and your server should be running.

To run tests in the future, without setup, run `bundle exec rake`.
To start up the server without all the setup `bundle exec rails s` should do
the trick!

Visit [localhost](http://localhost:3000) and you'll be dropped onto the support hero
schedule for the current month.

## The Nitty Gritty

The UI for the Support Hero app is super sparse. After working on this for a decent
chunk of time, I didn't exactly feel the inspiration to pull forth anything
resembling a decent design from the aether. My apologies for that. I made a few
minor changes to the layout, setting a `<header>` and `<nav>` element, but in general
didn't do anything with the CSS, which, doesn't exactly help me show of my skills
there.

Regarding the front-end code, the main thing that amused me was my ability to make
it so that all Day display was handled by a single partial, and yet also provide
context-dependent links/actions. This was done through passing the linkbar local
variable set to the partial address that I wanted rendered for that context. I
did this primarily because I absolutely abhor if statements in views. Really any
kind of flow control in a view makes me twitchy. However, I do also like the
ability to make a change to a common element in one place and have it show up in
all the contexts. This bit of metaprogramming-esque trickery is how I approach the
balance.

I made the choice to primarily use links in this, mostly because I was unconcerned
with security in this context, and without sufficient CSS, having forms and buttons
for various actions looks... weird. In an actual application that was being deployed
I would use the forms and buttons as appropriate in order to protect against CSRF
and the like.

Regarding the back-end code, I did something a bit peculiar, that being only
creating Day objects on the days in which support heroes were needed. I constrained
the creation of Day objects by defining two validations, one concerned with weekends
utilizing the date attribute's `#wday` method, and one concerned with holidays. The
holiday constraint is where I first really dug into the code.

When I had the list of holidays in front of me, my initial thought was to just input
the holidays, similar to Day objects, with a single date attribute, and a name.
However, it then occurred to me that if this system were to extend into the future
indefinitely, that would require inputting every single holiday. So I then thought,
well, how about just storing the month and day and checking against those? For some
holidays, this approach works perfectly fine. Independence Day, Christmas, and
Cesar Chavez Day all fall on the same day every year... But what about Thanksgiving,
Memorial Day, and Labor Day? I then realized I had to make a system that could
interpret, what I referred to as, relative holidays, holidays where the
specification is "The last Monday in May" and the like. My approach was to break
down that grammatical context and compute the relative holidays on the fly. By
recording only the day of the week, month, and "occurrence" (first, third, last, etc.)
I was able to do a smart lookup and calculation based on a given year. Effectively,
a RelativeHoliday is looked for with a given date's day of week and month, and then
calculated if one is found.

This worked fine and dandy, and I was quite pleased with myself until I saw one
holiday: Thanksgiving Friday. My heart sank. Here was a RelativeHoliday that was
almost identical to the others, with the one edge case that the holiday it was
relative to would be the fourth Thursday in November, and it could be the fifth
Friday in November. Back to the drawing board.

I came up with the concept of an offset RelativeHoliday. Most holidays could be
defined easily enough without an offset, or an offset of 0. In order to handle this
edge case, I have the RelativeHolidays without an offset perform as they did. If
no RelativeHoliday with an offset of 0 is found, we then check to see if a
RelativeHoliday with an offset exists in the month being checked. If so, we then
iterate over those RelativeHolidays to determine their date for the given year.
As most RelativeHolidays will not have an offset, this is typically acceptable.

Everything else should be pretty self-explanatory when you consider the Day
framework and how it works. `Day#next_valid` creates/obtains the next valid
Day object, allowing you to iterate infinitely as you please. An example of this
can be found in the ScheduleCreator class, which creates the defaults that were
specified in the problem description.

Heroes can define as many UndoableDay objects as they please, which associate them
negatively with a given date. I decided to make a punishment for anyone who says
that a day is undoable and then goes back and says they can actually do it. They are
assigned the Day that they had spurned as penance.

There is one issue that this particular approach has currently, and that is there
is no way to create Days through the UI currently. If the scope moves beyond the
40 days that are populated from setup, what will end up happening is a Day object
without a Hero will be created. I overrode the `Day#hero` method to check for an
associated Hero. If one is not found, it instantiates a NullHero, which follows the
Null Object Pattern. This was done so I can continue to despise conditionals/flow
control statements in views, primarily. But also allows me to, using a Hero-like object
find any and all Days without a Hero associated with them.

The last thing to really talk about was the approach for rescheduling when a Day is
marked as an UndoableDay for a given Hero. Basically, I chose an approach that does a
simple search and swap rather than reshuffling the entire schedule. It ensures that the
Day that is being swapped with has not already come to pass, but otherwise is identical
to the swap methodology, except that you can't choose which day you're swapping to. This
algorithm has it's flaws. Primarily, it can be locked out of being able to find a
replacement if there is a situation where a Hero has marked all of another Hero's days
as UndoableDays, but there are no other Heroes who do not have the UndoableDay available.
Basically, there are situations where a multi-user swap could solve the problem, but I
figured I had enough on my plate in making the rest of this app to solve an edgecase.

## In Closing

If you're so inclined, feel free to respond to this and have me
build out more features on this as desired. I really wouldn't mind some small
collaboration and back-and-forth to give you a feel for what it is like to
work with me more directly. If you'd like to see what I can do regarding CSS
I'd be more than happy to do some design of this UI, I just wasn't particularly feeling
ambitious with that aspect of this coding challenge, as I wanted to get this to you
by the beginning of the day on Friday.

Thanks!
