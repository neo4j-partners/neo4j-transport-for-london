//01 - Create Stations
LOAD CSV WITH HEADERS FROM 'https://storage.googleapis.com/leerazo-demos/london_transport/datasets/London_stations.csv' AS row
CREATE (s:Station {latitude:toFloat(row.Latitude), longitude:toFloat(row.Longitude), name:row.Station, zone:row.Zone})


//02 - Connect Stations (APOC)
LOAD CSV WITH HEADERS FROM 'https://storage.googleapis.com/leerazo-demos/london_transport/datasets/London_tube_lines.csv' as row
MATCH (a:Station), (b:Station) WHERE a.name = row.From_Station AND b.name = row.To_Station
CALL apoc.create.relationship(a, toUpper(row.Tube_Line), {}, b)
YIELD rel as rel1
CALL apoc.create.relationship(b, toUpper(row.Tube_Line), {}, a)
YIELD rel as rel2
RETURN rel1, rel2;

//02 - Connect Stations (BASIC)
LOAD CSV WITH HEADERS FROM 'https://storage.googleapis.com/leerazo-demos/london_transport/datasets/London_tube_lines.csv' as row
MATCH (a:Station), (b:Station) WHERE a.name = row.From_Station AND b.name = row.To_Station
CREATE (a)-[r:CONNECTED {line:toUpper(row.Tube_Line)}]->(b)

//03 - Reverse Connect Stations (APOC)
LOAD CSV WITH HEADERS FROM 'https://storage.googleapis.com/leerazo-demos/london_transport/datasets/London_tube_lines.csv' as row
MATCH (a:Station), (b:Station) WHERE a.name = row.From_Station AND b.name = row.To_Station
CALL apoc.create.relationship(b, toUpper(row.Tube_Line), {}, a)
YIELD rel
RETURN rel;

//04 - Delete Graph
match (a) detach delete a