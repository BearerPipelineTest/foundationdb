/*
 * ProtocolVersion.h
 *
 * This source file is part of the FoundationDB open source project
 *
 * Copyright 2013-2022 Apple Inc. and the FoundationDB project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once
#include "flow/Trace.h"
#include <cstdint>

constexpr int noBackwardsCompatibility = 13;

// The first check second expression version doesn't need to change because it's just for earlier protocol versions.
#define API_VERSION_FEATURE(v, x)                                                                                      \
	static_assert(v <= @FDB_AV_LATEST_VERSION@, "Feature protocol version too large");                                   \
	struct x {                                                                                                         \
		static constexpr uint64_t apiVersion = v;                                                                      \
	};                                                                                                                 \
	constexpr bool has##x() const { return this->version() >= x ::apiVersion; }                                        \
	static constexpr ApiVersion with##x() { return ApiVersion(x ::apiVersion); }

class ApiVersion {
	int _version;

public:
	// Statics.
	constexpr static int LATEST_VERSION = @FDB_AV_LATEST_VERSION@;
	constexpr static int FUTURE_VERSION = @FDB_AV_FUTURE_VERSION@;

	constexpr explicit ApiVersion(int version) : _version(version) {}
	constexpr ApiVersion() : _version(0) {}

	constexpr bool isValid() const {
		return version() > noBackwardsCompatibility && version() <= LATEST_VERSION;
	}

	constexpr int version() const { return _version; }

	// comparison operators
	constexpr bool operator==(const ApiVersion other) const { return version() == other.version(); }
	constexpr bool operator!=(const ApiVersion other) const { return version() != other.version(); }
	constexpr bool operator<=(const ApiVersion other) const { return version() <= other.version(); }
	constexpr bool operator>=(const ApiVersion other) const { return version() >= other.version(); }
	constexpr bool operator<(const ApiVersion other) const { return version() < other.version(); }
	constexpr bool operator>(const ApiVersion other) const { return version() > other.version(); }

public: // introduced features
    API_VERSION_FEATURE(@FDB_AV_SNAPSHOT_RYW@, SnapshotRYW);
    API_VERSION_FEATURE(@FDB_AV_INLINE_UPDATE_DATABASE@, InlineUpdateDatabase);
	API_VERSION_FEATURE(@FDB_AV_PERSISTENT_OPTIONS@, PersistentOptions);
    API_VERSION_FEATURE(@FDB_AV_CLUSTER_SHARED_STATE_MAP@, ClusterSharedStateMap);
	API_VERSION_FEATURE(@FDB_AV_TENANTS_V1@, TenantsV1);
    API_VERSION_FEATURE(@FDB_AV_BLOB_RANGE_API@, BlobRangeApi);
    API_VERSION_FEATURE(@FDB_AV_CREATE_DB_FROM_CONN_STRING@, CreateDBFromConnString);
    API_VERSION_FEATURE(@FDB_AV_FUTURE_GET_BOOL@, FutureGetBool);
    API_VERSION_FEATURE(@FDB_AV_FUTURE_PROTOCOL_VERSION_API@, FutureProtocolVersionApi);
	API_VERSION_FEATURE(@FDB_AV_TENANTS_V2@, TenantsV2);
};
