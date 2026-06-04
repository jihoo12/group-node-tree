-- Data 생성자 이름이 타입과 겹치면 안 됨
data PrimData
    = PInt Int
    | PStr String
    | PFloat Float
    | PBool Bool
    deriving (Show)

data Object
    = Group [Object]   -- 재귀적 그룹
    | Leaf PrimData    -- 단말 값
    deriving (Show)

data Tree
    = Node Object Object
    | Empty
    deriving (Show)

-- Object 안에서 조건을 만족하는 첫 번째 값 찾기
search :: (PrimData -> Bool) -> Object -> Maybe Object
search predicate obj = case obj of
    Leaf d ->
        if predicate d then Just (Leaf d)
        else Nothing
    Group children ->
        foldr (\child acc -> case acc of
            Just x  -> Just x
            Nothing -> search predicate child
        ) Nothing children

-- Group의 끝에 Object를 추가
-- Leaf에는 추가할 수 없으므로 Either로 처리
add :: Object -> Object -> Either String Object
add newObj target = case target of
    Group children -> Right (Group (children ++ [newObj]))
    Leaf _         -> Left "Leaf에는 추가할 수 없습니다"

-- 조건을 만족하는 모든 Leaf 제거 (재귀적)
remove :: (PrimData -> Bool) -> Object -> Object
remove predicate obj = case obj of
    Leaf d ->
        -- 제거 대상이면 빈 그룹으로 대체 (또는 Maybe 반환 방식도 가능)
        if predicate d then Group []
        else Leaf d
    Group children ->
        Group (filter (not . isEmpty) (map (remove predicate) children))

-- 빈 그룹 여부 확인 헬퍼
isEmpty :: Object -> Bool
isEmpty (Group []) = True
isEmpty _          = False

main :: IO ()
main = do
    let tree = Node
                (Group [Leaf (PInt 1), Leaf (PStr "hello"), Leaf (PInt 42)])
                (Leaf (PBool True))

    -- search
    let Node left _ = tree
    print $ search (\d -> case d of { PStr _ -> True; _ -> False }) left
    -- Just (Leaf (PStr "hello"))

    -- add
    print $ add (Leaf (PFloat 3.14)) left
    -- Right (Group [Leaf (PInt 1), Leaf (PStr "hello"), Leaf (PInt 42), Leaf (PFloat 3.14)])

    -- remove (정수만 제거)
    print $ remove (\d -> case d of { PInt _ -> True; _ -> False }) left
    -- Group [Leaf (PStr "hello")]