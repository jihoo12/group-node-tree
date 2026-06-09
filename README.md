# Project Documentation: `group-node-tree`

## Purpose
This project defines and manipulates a specialized tree structure designed to encapsulate heterogeneous data types (`PrimData`) and organize them into nested groups (`Object`). It provides functions for searching, appending elements, and selectively removing leaf nodes based on provided predicates.

## File Architecture
*   `group-node-tree.hs`: Contains the primary definition of data structures ( `PrimData`, `Object`, `Tree`) and implementing functions (`search`, `add`, `remove`). It also contains the execution entry point (`main`).

## Prerequisites
This project requires a Haskell compiler environment, such as GHC (Glasgow Haskell Compiler). No external libraries are imported beyond standard prelude functionality.

## Data Structures Defined

**`PrimData`**: A sum type representing atomic data types used as leaf values.
*   `PInt Int`: Wraps an integer value.
*   `PStr String`: Wraps a string value.
*   `PFloat Float`: Wraps a floating-point value.
*   `PBool Bool`: Wraps a boolean value.

**`Object`**: Defines the structure for nodes within the tree hierarchy.
*   `Group [Object]`: A container holding an ordered list of child `Object`s (recursive).
*   `Leaf PrimData`: A terminal node wrapping a single piece of primitive data.

**`Tree`**: Represents the overall structure, which is either a root `Node` or `Empty`.
*   `Node Object Object`: Defined as having two primary components (left and right child objects).
*   `Empty`: Represents an empty tree structure.

## Function Reference

### `search :: (PrimData -> Bool) -> Object -> Maybe Object`
Searches the provided `Object` recursively. It returns `Just Object` containing the first encountered object whose contained leaf data satisfies the given predicate function, or `Nothing` if no such object is found.

### `add :: Object -> Object -> Either String Object`
Appends a new `Object` to a target `Object`. The operation is constrained: it only succeeds if the `target` object is of type `Group`; otherwise, it returns `Left "Leaf에는 추가할 수 없습니다"`. If successful, it wraps the resulting list in `Right (Group [...])`.

### `remove :: (PrimData -> Bool) -> Object -> Object`
Removes objects from an `Object` recursively based on a predicate function applied to leaf data.
*   If a leaf satisfies the predicate, it is replaced by an empty `Group []`.
*   The function processes all children and subsequently filters out any resulting empty groups (`isEmpty`) that arise from removal operations.

### `isEmpty :: Object -> Bool`
A helper function that returns `True` if the provided `Object` is a `Group` containing no elements (`Group []`), and `False` otherwise.

## Usage Instructions

To compile and execute the application, run the following command in the terminal:

```bash
runhaskell group-node-tree.hs
```

**Execution Flow:**
The program executes the code defined within the `main` function:

1.  **Initialization**: A root `Tree` is instantiated using a predefined structure:
    *   Left Object (Group): Contains three leaves (`PInt 1`, `PStr "hello"`, `PInt 42`).
    *   Right Object (Leaf): Contains one boolean leaf (`PBool True`).

2.  **Search Example**: The script calls `search` on the left object, using a predicate that checks for strings (`PStr _ -> True`). It prints the resulting value to standard output.

3.  **Add Example**: The script calls `add`, attempting to append `Leaf (PFloat 3.14)` to the initialized left object. It prints the result of this operation to standard output, which will be wrapped in a Right constructor.

4.  **Remove Example**: The script calls `remove` on the left object, using a predicate that checks for integers (`PInt _ -> True`). It prints the final resulting `Object` structure, which filters out all removed integer nodes.