# Hoova

## The Bitcoin Wallet Sweeper Agent

## Project Information Page
[http://agoristradio.github.com/hoova/](http://agoristradio.github.com/hoova/)

#### Warning: This code is in alpha development stage. It is not ready for use. Especially with Real Money.

# Hoova Ruby Library Developers Usage

```
git clone git@github.com:AgoristRadio/hoova.git
cd hoova
bundle install
```

Currently there are no rspec specific tests, they are coming.
Right now its just Cucumber/Rspec. So you can just edit
the features/wallet_sweeping.feature and features/wallet_steps.rb
files to change your TESTNET wallet rpc info and your destination addresses.

Yes I know its not all standard and best practice, but this is
a work in progress toward it.

So to run tests then just do cucumber:

```
cucumber
```

### Examples

See the examples folder for how you would actually use this
in your own app or cron jobs etc.

