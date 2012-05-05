class GameplayController < UIViewController
  @@SCREEN_WIDTH = 320
  @@SCREEN_HEIGHT = 480
  @@BORDER_PADDING = 30
  @@IMG_WIDTH = 100
  @@IMG_HEIGHT = 100
  @@START_WITH_N_BIRDS = 5

  def viewDidLoad
    @birds_killed = 0
    @@START_WITH_N_BIRDS.times do
      view.addSubview(getNewBird)
    end
  end

  def getNewBird
    new_frame = CGRectMake(
      myRandom(@@BORDER_PADDING, @@SCREEN_WIDTH - @@IMG_WIDTH - @@BORDER_PADDING), 
      myRandom(@@BORDER_PADDING, @@SCREEN_HEIGHT - @@IMG_HEIGHT - @@BORDER_PADDING), 
      @@IMG_WIDTH, 
      @@IMG_HEIGHT
    )
    
    img = UIImageView.alloc.initWithFrame(new_frame);
    img.animationImages = [
      UIImage.imageNamed("bird1.png"),
      UIImage.imageNamed("bird2.png"), 
      UIImage.imageNamed("bird3.png"),
      UIImage.imageNamed("bird4.png")
    ]    
    img.animationDuration = 1.0;
    img.animationRepeatCount = 0;
    img.startAnimating

    img_button = UIButton.buttonWithType(UIButtonTypeCustom)
    img_button.addTarget(self, action: "actionTapped:", forControlEvents:UIControlEventTouchUpInside)
    img_button.frame = CGRectMake(0, 0, @@IMG_WIDTH, @@IMG_HEIGHT)

    img.addSubview(img_button);
    img.bringSubviewToFront(img_button);
    img.setUserInteractionEnabled(true);

    return img
  end

  def actionTapped(sender)
    img_button = sender
    img = sender.superview
    view = img.superview
    img_button.removeFromSuperview

    img.stopAnimating
    img.image = UIImage.imageNamed("killed.png")
    UIView.animateWithDuration(0.175, delay:0.0, options:UIViewAnimationOptionTransitionCrossDissolve,
                               animations:lambda { img.alpha = 0.0 },
                               completion:lambda { |is_finished| img.removeFromSuperview if is_finished })
    # and add another one :-)
    view.addSubview(getNewBird)
    @birds_killed = @birds_killed + 1
    puts "Birds Killed = ", @birds_killed
  end

  def myRandom(from, to)
    # alternative
    return rand(to-from)+from
    #return (from..to).to_a.sample
  end
end