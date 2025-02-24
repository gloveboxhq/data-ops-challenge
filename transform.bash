#!/usr/bin/env bash
set -euo pipefail

jq -rs '
	[ "user_id", "name", "email", "phone" ],
	(
		.[] |
		.user_id as $id |
		.name as $name | (
			( .emails[] | [ $id , $name , .   , null ] ),
			[ "TODO", "add", "phone", "here" ]
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

echo "TODO xsv join" | tee $BUILD_DIR/user-policies.csv



