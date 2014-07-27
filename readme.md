# What is it ?

This repository holds the list of all currently available audio TEDTalks. It
does not contain the `mp3` files, but provides `json` files with all the
necessary metadata.

I build this list myself while developing a simple script to automatically
download the audio podcasts. And I thought it would be nice to share this
information so others won't have to scrap the API, parse CSV files, read RSS
feeds like I had to do to get a full list.

## Usage

Feel free to browse the `./src/talks` folder. You'll find metadata about any
available talk in `json` format.

There is also a `./download-all.sh` script that contains `wget` instructions
for downloading every single audio TEDTalk. Feel free to copy and edit it
before running it to specify only the talks you're interested in.

## Update

I'll try to keep this repository as much up to date as possible. But you can
manually update it by running the `$ ./scripts/update` command. This will parse
the RSS feed and download any new talk available on the feed and not yet
downloaded.

You can alternatively use  `$ ./scripts/talk-downloader 1234` script to
download metadata about talk #1234. You can also use `$
./scripts/talk-downloader 1000 1200` to download all metadatas for talks from
 #1000 to #1200.


## Sources

Here are the various sources I had to use while building the tool.

- [TED API](http://developer.ted.com/)
- [List of all audio
  podcasts](https://spreadsheets.google.com/a/octo.com/pub?key=0Ahz_ZQm7pkwTdFBVWXBLOFNGSkdsVFgxc0Y0bk9lc0E&hl=en&output=html)
- [RSS Podcast](http://feeds.feedburner.com/TEDTalks_audio)
- [Castroller History](http://castroller.com/podcasts/tedtalksaudio)
