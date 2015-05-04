# scoring

Welcome and thanks for the interest in the project. 

At this time, it's highly unlikely we accept pull requests from outside the organization itself unless it cures cancer or magically makes someone an instant cyberwarrior.

To actually pull this code, go ahead and download it and either pick the bash or python setup.

The only functioning one is currently bash. It also only runs on init systems so far but you could probably comment out the services part and it'll work again.

The process for bash is as follows:
1) Setup your image
2) Run ./setupimg.sh to specify what you actually want scored
3) setupimg.sh will generate a (insecurely) encoded config file. Easily decode it with base64 --decode
4) Make ./scorer.sh run whenever it should be scored AS ROOT (maybe chmod +s it?). Scorer.sh needs to be in the same folder as the generated config file however.
	An example is having it in .bashrc and aliased.
	nano /root/.bashrc
	These two lines:
		/absolute/path/to/scorer.sh
		alias "score=/absolute/path/to/scorer.sh"

Now whenever they elevate to root or whenever they run "score" as root, it'll score.

To deploy the bash version
		cd ~
		wget https://github.com/mike-bailey/scoring/archive/master.zip
		unzip master.zip
		cd bash
		chmod +x ./scorer.sh
		chmod +x ./setupimg.sh
		*DO YOUR IMAGE CONFIGURATION*
		./setupimg.sh
	
To score, run these as root
	nano /root/.bashrc
	and add the lines:
	/absolutepath/to/scorer.sh
	alias score="/absolutepath/to/scorer.sh"
	
It'll run whenever you elevate as root or whenever you run score as root
