# Changelog

!!! note
	This is the Changelog for the TrackBuilder plugin

    Based on [https://keepachangelog.com/en/1.0.0/](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

## [0.1.0] - 2021-01-04

### Added

- Able to Build TrackGroups from the GUI
	- Load TrackGroups and Tracks from the GUI
	- Set Start and End Position
- Overhauled type checking to use [t](https://github.com/osyrisrblx/t)
- Build Pattern constructors for:
	- Segments
	- Section
	- TrackGroup
	- PhysicsRails
	- MeshData
	- CFrameTracks
- fromInstance constructors for:
	- Segments
	- Section
	- PhysicsRails
	- TrackGroup
- Added Section SegmentOffset
- MidTrackObject Segment
- Plugin Version Text

### Changed

- Section
	- Interval to SegmentLength

### Fixed

- Crossbeam offsets not being passed correctly
- Reduced amount of Promises created for Section:CreateAsync()
- Optimization not using Segment's own offsets

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
