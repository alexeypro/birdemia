class GameplayController < UIViewController
  @@SCREEN_WIDTH = 320
  @@SCREEN_HEIGHT = 480
  @@BORDER_PADDING = 30
  @@FONT_SIZE = 22
  @@IMG_WIDTH = 100
  @@IMG_HEIGHT = 100
  @@START_WITH_N_BIRDS = 5

  @@TWEET_LINK = "https://twitter.com/intent/tweet?source=birdemia&text="
  @@FBSHARE_LINK = "http://www.facebook.com/sharer.php?u=http%3A%2F%2Fbit.ly%2Fbirdemia&t="

  def viewDidLoad
    gameStart
  end

  def getColor(r, g, b)
    return UIColor.colorWithRed(r/255.0, green:g/255.0, blue:b/255.0, alpha:1.0)
  end  

  def gameStart
    @birds_killed = 0
    @time  = 1.0
    @label = UILabel.alloc.init
    @label.text = sprintf("00:%02d", @time)
    @label.frame = CGRectMake(0, @@FONT_SIZE, @@SCREEN_WIDTH, @@BORDER_PADDING)
    @label.font = UIFont.fontWithName("Copperplate-Bold", size: @@FONT_SIZE)
    @label.textAlignment = UITextAlignmentCenter
    @label.backgroundColor = UIColor.clearColor;
    @label.textColor = getColor(95, 77, 77) #5F4D4D = 95,77,77
    view.addSubview(@label)
    @@START_WITH_N_BIRDS.times do
      view.addSubview(getNewBird)
    end
    # start timer
    if @timer == nil
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerHandler:", 
                                                      userInfo: nil, repeats: true)
    end
    return true
  end

  def timerHandler(userInfo)
    @time += 0.1
    @label.text = sprintf("got %03d in %02d seconds", @birds_killed, @time)
    if @time >= 19 && @time <= 25.0
      @label.textColor = getColor(153, 31, 0)   #991F00 = 153, 31, 0
    elsif @time > 25.0 && @time < 30.0
      @label.textColor = getColor(209, 25, 25)  #D11919 = 209, 25, 25
    elsif @time >= 5.0 #30.0
      @timer.invalidate
      @timer = nil
      gameEnd
    end
  end

  def gameEnd
    NSLog("Game just ended -- you got " + @birds_killed.to_s + " birds killed!")
    # get all image views and kill them all!
    view.subviews.makeObjectsPerformSelector("removeFromSuperview")
    # now let's offer you to facebook, tweet or repeat
    alert = UIAlertView.alloc.initWithTitle("Birdaaaalicious..",
                              message: "Wow! " + @birds_killed.to_s + " birds killed!",
                              delegate: self,
                              cancelButtonTitle:"Play again",
                              otherButtonTitles:nil)
    alert.addButtonWithTitle("Post on Facebook")
    alert.addButtonWithTitle("Tweet to Twitter")
    alert.show
  end

  def getShareMessage(birdsKilled)
    return "Just%20killed%20" + birdsKilled.to_s + "%20birds%20in%20Birdemia%20game%20http%3A%2F%2Fbit.ly%2Fbirdemia%20%23birdemia%20%23ios%20via%20%40alexeypro%20%23FB"
  end

  def openURLandStartAgain(url)
    UIApplication.sharedApplication.openURL(NSURL.URLWithString(url))
    alert = UIAlertView.alloc.initWithTitle("Birdemia",
                              message: "Thanks for sharing!",
                              delegate: self,
                              cancelButtonTitle:"Play again",
                              otherButtonTitles:nil)
    alert.show
  end

  def alertView(alertView, clickedButtonAtIndex:buttonIndex)
    if buttonIndex == 1
      openURLandStartAgain(@@FBSHARE_LINK + getShareMessage(@birds_killed))
    elsif buttonIndex == 2
      openURLandStartAgain(@@TWEET_LINK + getShareMessage(@birds_killed))
    else
      # pretty much any other case will start game again :-)
      gameStart
    end
  end

  def getNewBird
    new_frame = CGRectMake(
      myRandom(0, @@SCREEN_WIDTH - @@IMG_WIDTH - 0), 
      myRandom(@@BORDER_PADDING + @@FONT_SIZE, @@SCREEN_HEIGHT - @@IMG_HEIGHT), 
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
    @birds_killed += 1
  end

  def myRandom(from, to)
    # alternative: return rand(to-from)+from
    return (from..to).to_a.sample
  end
end