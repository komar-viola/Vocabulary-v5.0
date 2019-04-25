--A small script for publishing a release on GitHub
--Returns the release_id if success
CREATE OR REPLACE FUNCTION vocabulary_pack.py_git_release(git_repo text, release_title text, release_body text, release_tag text, git_token text)
RETURNS text AS
$BODY$
  import json
  from urllib2 import urlopen, Request

  url_template = 'https://{}.github.com/repos/' + git_repo + '/releases'
  
  try:
    _json = json.loads(urlopen(Request(
        url_template.format('api'),
        json.dumps({
            'tag_name': release_tag,
            'name': release_title,
            'body': release_body
        }).encode(),
        headers={
            'Accept': 'application/vnd.github.v3+json',
            'Authorization': 'token ' + git_token,
        },
    ),
    timeout=30).read().decode())
    release_id = _json['id']
  except Exception, e:
    release_id = str(e)
  return release_id
$BODY$
LANGUAGE 'plpythonu'
SECURITY INVOKER;