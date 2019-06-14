module Ex01a


open FStar.Exn
open FStar.All

type filename = string

let canWrite (f : filename) =
  match f with
  | "demo/tempfile" -> true
  | _ -> false

let canRead (f : filename) =
  canWrite f
  || f = "demo/README"


val read : f : filename {canRead f} -> ML string
let read f = FStar.IO.print_string("Dummy read of file " ^ f ^ "\n"); f

val write : f:filename{canWrite f} -> string -> ML unit
let write f s = FStar.IO.print_string ("Dummy write of string " ^ s ^ " to file " ^ f ^ "\n")


  // BEGIN: UntrustedClientCode
  let passwd : filename = "demo/password"
  let readme : filename = "demo/README"
  let tmp    : filename = "demo/tempfile"
  // END: UntrustedClientCode

  // BEGIN: StaticChecking
  val staticChecking : unit -> ML unit
  let staticChecking () =
    let v1 = read tmp in
    let v2 = read readme in
    // let v3 = read passwd in // invalid read, fails type-checking
    write tmp "hello!"
    // ; write passwd "junk" // invalid write , fails type-checking
  // END: StaticChecking


  exception InvalidRead
  val checkedRead : filename -> ML string
  let checkedRead f =
    if canRead f then read f else raise InvalidRead


  exception InvalidWrite
  val checkedWrite : filename -> string -> ML unit
  let checkedWrite f s =
    if canWrite f then write f s else raise InvalidWrite
