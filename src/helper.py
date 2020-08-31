'''
  Copyright (C) 2018  DH Electroncis GmbH
  Contact: https://www.dh-electronics.com/
'''
import cog

def getSettingsDef():
	import json
	with open('SettingDefinition.json') as f:
		json_array = json.load(f)
	return json_array['settings']

def first_lower(s):
	if len(s) == 0:
		return s
	else:
		return s[0].lower() + s[1:]
