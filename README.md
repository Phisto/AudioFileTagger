## Overview

The AudioFileTagger framework provides facilities for reading metadata from files and tagging MP3 files with ID3v2 tags.


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


## TagLib

The AudioFileTagger framework is using [TagLib](https://taglib.org/) to tag the encoded MP3 files with ID3v2 tags.
TagLib is a library for reading and editing the meta-data of several popular audio formats. TagLib is distributed under the GNU Lesser General Public License (LGPL) and Mozilla Public License (MPL). 


## License

AudioFileTagger is released under the GNU Lesser General Public License (LGPL). 

See <http://www.gnu.org/licenses/> for details.





