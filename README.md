[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/github/license/phisto/AudioFileTagger.svg)](https://github.com/Phisto/AudioFileTagger)

## Overview

The AudioFileTagger framework provides facilities for reading metadata from audio files and tagging MP3 files with ID3v2 tags.


## Requirements

- macOS 10.10+
- Xcode 10.1+


## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate AudioFileTagger into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Phisto/AudioFileTagger" ~> 1.0
```


### Manually

If you prefer not to use Carthage, you can integrate AudioFileTagger into your project manually.
You only need to build and add the AudioFileTagger framework (AudioFileTagger.framework) to your project. 


## Usage

```objectivec

NSURL *fileURL = <#...#>
Metadata *meta = [[Metadata alloc] initWithMetadataFromFile:fileURL];
if (metadata) {
    
    NSLog(@"\n");
    NSLog(@"title: %@", meta.title);
    NSLog(@"artist: %@", meta.artist);
    NSLog(@"albumName: %@", meta.albumName);
    NSLog(@"\n");
}

MP3Tagger *tagger = [MP3Tagger taggerWithMetadata:meta];
if (!tagger) {
    <#// handle failure...#>
}

NSURL *mp3FileToTag = <#...#>
BOOL erfolg = [tagger tagFile:fileToTag];
if (!erfolg) {
    <#// handle failure...#>
}

```


## TagLib

The AudioFileTagger framework is using [TagLib](https://taglib.org/) to tag MP3 files with ID3v2 tags.
TagLib is a library for reading and editing the meta-data of several popular audio formats. TagLib is distributed under the [GNU Lesser General Public License (LGPL)](https://www.gnu.org/licenses/) and [Mozilla Public License (MPL)](https://www.mozilla.org/en-US/MPL/). 

I made a [(Fork)](https://github.com/Phisto/TagLib) of the [official](https://taglib.org/) 1.11.1 Release, so i can easily import the taglib framwork via Carthage.


## License

AudioFileTagger is released under the [GNU Lesser General Public License (LGPL)](https://www.gnu.org/licenses/). 
