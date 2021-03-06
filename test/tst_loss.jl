
function test_deriv(l::MarginBasedLoss, t_vec)
  for y in [-1., 1], t in t_vec
    if isdifferentiable(l, y*t)
      d_dual = y * epsilon(value(l, dual(y, 0), dual(t, 1)))
      d_comp = deriv(l, y, t)
      @test abs(d_dual - d_comp) < 1e-10
      val = value(l, y, t)
      val2, d_comp2 = value_deriv(l, y, t)
      val3, d_comp3 = value_deriv_fun(l)(y, t)
      val4, d_comp4 = value_deriv(l, y * t)
      @test_approx_eq val val2
      @test_approx_eq val val3
      @test_approx_eq val val4
      @test_approx_eq val value(l, y, t)
      @test_approx_eq val value(l, y*t)
      @test_approx_eq val value(l, [2,3], y, t)
      @test_approx_eq val value_fun(l)(y, t)
      @test_approx_eq val value_fun(l)(y*t)
      @test_approx_eq val repr_fun(l)(y*t)
      @test_approx_eq val l(y*t)
      @test_approx_eq d_comp d_comp2
      @test_approx_eq d_comp d_comp3
      @test_approx_eq d_comp d_comp4
      @test_approx_eq d_comp deriv(l, y*t)
      @test_approx_eq d_comp deriv(l, [2,3], y, t)
      @test_approx_eq d_comp deriv_fun(l)(y, t)
      @test_approx_eq d_comp deriv_fun(l)(y*t)
      @test_approx_eq d_comp repr_deriv_fun(l)(y*t)
      @test_approx_eq d_comp l'(y*t)
    else
      # y*t == 1 ? print(".") : print("(no $(y)*$(t)) ")
      print(".")
    end
  end
  println("ok")
end

function test_deriv(l::DistanceBasedLoss, t_vec)
  for y in -20:.2:20, t in t_vec
    if isdifferentiable(l, y-t)
      d_dual = epsilon(value(l, dual(y-t, 1)))
      d_comp = deriv(l, y, t)
      @test abs(d_dual - d_comp) < 1e-10
      val = value(l, y, t)
      val2, d_comp2 = value_deriv(l, y, t)
      val3, d_comp3 = value_deriv_fun(l)(y, t)
      val4, d_comp4 = value_deriv(l, y - t)
      @test_approx_eq val val2
      @test_approx_eq val val3
      @test_approx_eq val val4
      @test_approx_eq val value(l, y, t)
      @test_approx_eq val value(l, y-t)
      @test_approx_eq val value(l, [2,3], y, t)
      @test_approx_eq val value_fun(l)(y, t)
      @test_approx_eq val value_fun(l)(y-t)
      @test_approx_eq val repr_fun(l)(y-t)
      @test_approx_eq val l(y-t)
      @test_approx_eq d_comp d_comp2
      @test_approx_eq d_comp d_comp3
      @test_approx_eq d_comp d_comp4
      @test_approx_eq d_comp deriv(l, y-t)
      @test_approx_eq d_comp deriv(l, [2,3], y, t)
      @test_approx_eq d_comp deriv_fun(l)(y, t)
      @test_approx_eq d_comp deriv_fun(l)(y-t)
      @test_approx_eq d_comp repr_deriv_fun(l)(y-t)
      @test_approx_eq d_comp l'(y-t)
    else
      # y-t == 0 ? print(".") : print("$(y-t) ")
      print(".")
    end
  end
  println("ok")
end

function test_deriv2(l::MarginBasedLoss, t_vec)
  for y in [-1., 1], t in t_vec
    if istwicedifferentiable(l, y*t)
      d2_dual = y*epsilon(deriv(l, dual(y, 0), dual(t, 1)))
      d2_comp = deriv2(l, y, t)
      @test abs(d2_dual - d2_comp) < 1e-10
      @test_approx_eq d2_comp deriv2(l, y, t)
      @test_approx_eq d2_comp deriv2(l, y*t)
      @test_approx_eq d2_comp deriv2(l, [2,3], y, t)
      @test_approx_eq d2_comp deriv2_fun(l)(y, t)
      @test_approx_eq d2_comp deriv2_fun(l)(y*t)
    else
      # y*t == 1 ? print(".") : print("(no $(y)*$(t)) ")
      print(".")
    end
  end
  println("ok")
end

function test_deriv2(l::DistanceBasedLoss, t_vec)
  for y in -20:.2:20, t in t_vec
    if istwicedifferentiable(l, y-t)
      d2_dual = epsilon(deriv(l, dual(y-t, 1)))
      d2_comp = deriv2(l, y, t)
      @test abs(d2_dual - d2_comp) < 1e-10
      @test_approx_eq d2_comp deriv2(l, y, t)
      @test_approx_eq d2_comp deriv2(l, y-t)
      @test_approx_eq d2_comp deriv2(l, [2,3], y, t)
      @test_approx_eq d2_comp deriv2_fun(l)(y, t)
      @test_approx_eq d2_comp deriv2_fun(l)(y-t)
    else
      # y-t == 0 ? print(".") : print("$(y-t) ")
      print(".")
    end
  end
  println("ok")
end

# ==========================================================================

margin_losses = [LogitMarginLoss(), L1HingeLoss(), L2HingeLoss(), PerceptronLoss(),
                 SmoothedL1HingeLoss(.5), SmoothedL1HingeLoss(1), SmoothedL1HingeLoss(2),
                 ModifiedHuberLoss()]

msg("Test first derivatives of margin-based losses")

for loss in margin_losses
  msg2("$(loss): ")
  test_deriv(loss, -10:0.1:10)
end

msg("Test second derivatives of margin-based losses")

for loss in margin_losses
  msg2("$(loss): ")
  test_deriv2(loss, -10:0.1:10)
end

# ==========================================================================

distance_losses = [L2DistLoss(), LPDistLoss(2.0), L1DistLoss(), LPDistLoss(1.0),
                   LPDistLoss(0.5), LPDistLoss(1.5), LPDistLoss(3),
                   LogitDistLoss(), L1EpsilonInsLoss(0.5), EpsilonInsLoss(1.5),
                   L2EpsilonInsLoss(0.5), L2EpsilonInsLoss(1.5)]

msg("Test first derivatives of distance-based losses")

for loss in distance_losses
  msg2("$(loss): ")
  test_deriv(loss, -30:0.5:30)
end

msg("Test second derivatives of distance-based losses")

for loss in distance_losses
  msg2("$(loss): ")
  test_deriv2(loss, -30:0.5:30)
end
