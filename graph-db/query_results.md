# Gremlin Queries

## Query 1: Check if a key is present or not in the vertex

```gremlin
gremlin> g = traversal().withRemote(DriverRemoteConnection.using("0.0.0.0", 8182, "g"));
==>graphtraversalsource[emptygraph[empty], standard]
gremlin> g.V('af7c0ce7-9049-4d7d-99dd-7f18ed63b2df<>id_mid_1')
==>v[af7c0ce7-9049-4d7d-99dd-7f18ed63b2df<>id_mid_1]
gremlin>
```

## Query 2: Fetch the metadata corresponding to a key in the vertex
```gremlin
gremlin> g.V('af7c0ce7-9049-4d7d-99dd-7f18ed63b2df<>id_mid_1').values()
==>{"1879":["FRA","DEU"],"1290":["FRA"],"404":["FRA"],"320":["FRA"],"751":["FRA"],"212":["FRA"],"1332":["FRA"],"1590":["FRA"],"1822":["FRA"],"1491":["FRA"]}
==>{"1290":["Android"],"404":["Android"],"320":["Android"],"751":["Android"],"212":["ANDROID","Android"],"1332":["Android"],"1590":["Android"],"1822":["Android"],"1491":["Android"]}
==>{"1879":1703780520,"1290":1700597424,"404":1686355200,"320":1639094400,"751":1650844800,"212":1637697600,"1332":1639241580,"1590":1703721600,"1822":1698105600,"1491":1675296000}
```

## Query 3: Fetch all the connected IDs to the starting vertex
```gremlin
gremlin> startingVertex = g.V().has('~id', '+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23').next()
==>v[+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23]
gremlin>
==>v[c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_4]
==>v[ttzyMLXY9TGt2_tn4ovuNrSLp2OtjvtmuN3voIs4<>id_mid_65]
==>v[c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_61]
==>v[y-0OtbZdtE2or_6mNhQPIdrcIeie0T40cDAw--~A<>id_mid_24]
==>v[Mr2GgCMf<>id_mid_30]
==>v[+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23]
==>v[8147829665333440993<>id_mid_7]
==>v[28EA9204-2890-493B-9B73-A93165E5E024<>id_mid_33]
==>v[JVB5KX6E-25-2P0E<>id_mid_41]
==>v[6686063546329266316<>id_mid_20]
gremlin>
```

## Query 4: Query metadata corresponding to the vertex
```gremlin
gremlin> node = g.V().has('~id', '+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23').next()
==>v[+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23]
gremlin> metadata = g.V(node).valueMap().next()
==>dp_country=[{"602":["FRA"],"1361":["FRA"]}]
==>dp_os=[{}]
==>dp_ts=[{"602":1703875421,"1361":1703334598}]
gremlin>
```

## Query 5: Query the direct edge
```gremlin
gremlin> startingNode = g.V().has('~id', '+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23').next()
==>v[+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23]

gremlin> g.V(startingNode).both().toList()
==>v[c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_4]
```

## Query 6: Check if there is a direct edge between two IDs
```gremlin
gremlin> vertex1 = g.V().has('~id', '+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23').next()
==>v[+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23]
gremlin>
gremlin> vertex2 = g.V().has('~id', 'c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_4').next()
==>v[c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_4]
gremlin>
gremlin> vertex3 = g.V().has('~id', '+0HwhurMASRnUNUkBlvT7kFXepeSIuP2+S41iYitP1U=<>id_mid_23').next()
==>v[+0HwhurMASRnUNUkBlvT7kFXepeSIuP2+S41iYitP1U=<>id_mid_23]
gremlin>
gremlin> edge1 = g.V(vertex1).outE().where(inV().is(vertex3)).next()
java.util.NoSuchElementException
Type ':help' or ':h' for help.
Display stack trace? [yN]
gremlin>
gremlin> edge2 = g.V(vertex1).outE().where(inV().is(vertex2)).next()
==>e[///////u6P7//////+7o/g==][+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23-connected->c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_4]
gremlin>
```

## Query 7: Fetch metadata corresponding to an edge
```gremlin
gremlin> vertex1 = g.V().has('~id', '+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23').next()
==>v[+3ym+W7+1YA0kZMugNKnNGhHTv9nV4no+S41iYitP1U=<>id_mid_23]
gremlin>
gremlin> vertex2 = g.V().has('~id', 'c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_4').next()
==>v[c250fa59-0d94-450e-7ca1-91833725025c<>id_mid_4]
gremlin>
gremlin> g.V(vertex2).bothE().where(otherV().is(vertex1)).valueMap().toList()
==>[dp_country:{"1361":["FRA"],"602":["FRA"]},dp_ts:{"1361":1703334598,"602":1703875421}]
```