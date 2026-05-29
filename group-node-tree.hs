type Group = [Object]
data Data = 
    Int Int
    | Str String
    | Float Float
    | Bool Bool
data Object =
    Group Group
    | Object Data
data Tree = Node Object Object