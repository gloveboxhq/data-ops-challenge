#!/usr/bin/env bash

set -euo pipefail

jq -rs '
	[ "user_id", "name", "email", "phone" ],
	(
		.[] |
		.user_id as $id |
		.name as $name |
		(
			(.emails[]? | [ $id , $name , . , null ]),
			(.phones[]?  | [ $id , $name , null, . ])
		)
	)
	| @csv
' tests/input/users/*.json > $BUILD_DIR/users.csv

jq -rs '
	[ "user_id", "policy_number", "carrier", "policy_type", "effective_date", "expiration_date" ],
	(
		.[] | .[] |
			[
				.user_id,
				.policy_number,
				.carrier,
				.policy_type,
				.effective_date,
				.expiration_date
			]
	)
	| @csv
' tests/input/policies-by-user/*.json > $BUILD_DIR/policies.csv

xsv join user_id "$BUILD_DIR/policies.csv" user_id "$BUILD_DIR/users.csv" > "$BUILD_DIR/user-policies.csv"