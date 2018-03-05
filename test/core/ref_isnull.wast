(module
  (func $f1 (export "eqref") (param $x eqref) (result i32)
    (ref.isnull (get_local $x))
  )
  (func $f2 (export "anyref") (param $x anyref) (result i32)
    (ref.isnull (get_local $x))
  )
  (func $f3 (export "anyfunc") (param $x anyfunc) (result i32)
    (ref.isnull (get_local $x))
  )

  (table $t1 2 eqref)
  (table $t2 2 anyref)
  (table $t3 2 anyfunc) (elem $t3 (i32.const 1) $dummy)
  (func $dummy)

  (func (export "init") (param $r eqref)
    (set_table $t1 (i32.const 1) (get_local $r))
    (set_table $t2 (i32.const 1) (get_local $r))
  )
  (func (export "deinit")
    (set_table $t1 (i32.const 1) (ref.null))
    (set_table $t2 (i32.const 1) (ref.null))
    (set_table $t3 (i32.const 1) (ref.null))
  )

  (func (export "eqref-elem") (param $x i32) (result i32)
    (call $f1 (get_table $t1 (get_local $x)))
  )
  (func (export "anyref-elem") (param $x i32) (result i32)
    (call $f2 (get_table $t2 (get_local $x)))
  )
  (func (export "anyfunc-elem") (param $x i32) (result i32)
    (call $f3 (get_table $t3 (get_local $x)))
  )
)

(assert_return (invoke "eqref" (ref.null)) (i32.const 1))
(assert_return (invoke "anyref" (ref.null)) (i32.const 1))
(assert_return (invoke "anyfunc" (ref.null)) (i32.const 1))

(assert_return (invoke "eqref" (ref 1)) (i32.const 0))
(assert_return (invoke "anyref" (ref 1)) (i32.const 0))
(assert_return (invoke "anyfunc" (ref 1)) (i32.const 0))

(invoke "init" (ref 0))

(assert_return (invoke "eqref-elem" (i32.const 0)) (i32.const 1))
(assert_return (invoke "anyref-elem" (i32.const 0)) (i32.const 1))
(assert_return (invoke "anyfunc-elem" (i32.const 0)) (i32.const 1))

(assert_return (invoke "eqref-elem" (i32.const 1)) (i32.const 0))
(assert_return (invoke "anyref-elem" (i32.const 1)) (i32.const 0))
(assert_return (invoke "anyfunc-elem" (i32.const 1)) (i32.const 0))

(invoke "deinit")

(assert_return (invoke "eqref-elem" (i32.const 0)) (i32.const 1))
(assert_return (invoke "anyref-elem" (i32.const 0)) (i32.const 1))
(assert_return (invoke "anyfunc-elem" (i32.const 0)) (i32.const 1))

(assert_return (invoke "eqref-elem" (i32.const 1)) (i32.const 1))
(assert_return (invoke "anyref-elem" (i32.const 1)) (i32.const 1))
(assert_return (invoke "anyfunc-elem" (i32.const 1)) (i32.const 1))
