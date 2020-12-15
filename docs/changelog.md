# Changelog

!!! note
	This is the Changelog for the TrackBuilder plugin

    Based on [https://keepachangelog.com/en/1.0.0/](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

### Added

- Able to Build TrackGroups from the GUI
	- Load TrackGroups and Tracks from the GUI
	- Set Start and End Position
- Build Pattern constructors for:
	- Segments
	- Section
	- TrackGroup
- fromInstance constructors for:
	- Segments
	- Section
	- TrackGroup
- Added Section SegmentOffset (not implemented)

### Changed

- Section
	- Interval to SegmentLength

### Deprecated



### Fixed

- Crossbeam offsets not being passed correctly

## [0.0.2] - 2020-12-06

### Added

- Initial docs page

### Changed

- Renamed Tie to TrackObject
- Shortened module index names for PointToPointCFrameTrack and PointToPointCFrameTrack2
	- Now PointToPoint and PointToPoint2 respectfully

### Fixed

- CFrameTrack.IsType now exposed in the top module
	- Fixes type checking bug with BaseSection:Create()
- BuildLast with StartPosition > EndPosition

## [0.0.1] - 2020-12-06

- Uploaded to Github

### Added

- Very minimal GUI
	- Run Programs
	- Print Track Positions
