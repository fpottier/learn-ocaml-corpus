let return (x : 'a) : 'a m =
  let compute s f = s x f in
  { compute }

let (>>=) (m1 : 'a m) (f2 : 'a -> 'b m) : 'b m =
  let compute s f =
    m1.compute (fun x f' -> (f2 x).compute s f (* wrong: should be [f'] *)) f
  in
  { compute }

let fail : 'a m =
  let compute s f = f() in
  { compute }

let choose (m1 : 'a m) (m2 : 'a m) : 'a m =
  let compute s f = m1.compute s (fun () -> m2.compute s f) in
  { compute }

let sols (m : 'a m) : 'a Seq.t =
  fun () ->
    m.compute
      (fun x f -> Seq.Cons (x, f))
      (fun () -> Seq.Nil)
