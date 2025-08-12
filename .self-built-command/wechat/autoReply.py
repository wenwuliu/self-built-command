#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
WeChat Auto Reply Script
Author: liuwenwu
Description: Automatically reply to WeChat messages with status updates
"""

import sys
import time
import datetime
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def show_help():
    """Display usage information"""
    print("Usage: autoReply <minutes> <activity>")
    print("Automatically reply to WeChat messages with busy status")
    print("")
    print("Arguments:")
    print("  minutes   - Duration in minutes for the activity")
    print("  activity  - Description of current activity")
    print("")
    print("Example:")
    print("  autoReply 30 '开会'")
    print("  autoReply 60 '学习'")

def validate_arguments():
    """Validate command line arguments"""
    if len(sys.argv) != 3:
        print("Error: Invalid number of arguments", file=sys.stderr)
        show_help()
        sys.exit(1)
    
    try:
        minutes = int(sys.argv[1])
        if minutes <= 0:
            raise ValueError("Minutes must be positive")
    except ValueError as e:
        print(f"Error: Invalid minutes value '{sys.argv[1]}': {e}", file=sys.stderr)
        sys.exit(1)
    
    activity = sys.argv[2].strip()
    if not activity:
        print("Error: Activity description cannot be empty", file=sys.stderr)
        sys.exit(1)
    
    return minutes, activity

def main():
    """Main function"""
    try:
        # Import itchat with error handling
        try:
            import itchat
        except ImportError:
            print("Error: itchat module not found. Install with: pip install itchat", file=sys.stderr)
            sys.exit(1)
        
        # Validate arguments
        minutes, activity = validate_arguments()
        
        # Calculate timing
        start_time = time.time()
        total_seconds = minutes * 60
        
        logger.info(f"Starting auto-reply for {minutes} minutes, activity: {activity}")
        
        @itchat.msg_register(itchat.content.TEXT)
        def text_reply(msg):
            """Handle incoming text messages"""
            try:
                current_time = time.time()
                elapsed_seconds = int(current_time - start_time)
                
                if elapsed_seconds <= total_seconds:
                    remaining_minutes = int((total_seconds - elapsed_seconds) / 60)
                    reply = f"自动回复～ 正在{activity}中，大概剩余{remaining_minutes}分钟回来"
                else:
                    reply = f"预计{activity}{minutes}分钟，现在还没完成😅，请稍等片刻，我马上回来"
                
                logger.info(f"Auto-replied to {msg['FromUserName']}: {reply}")
                return reply
                
            except Exception as e:
                logger.error(f"Error in text_reply: {e}")
                return "自动回复出现问题，请稍后再试"
        
        # Login and run
        logger.info("Logging into WeChat...")
        itchat.auto_login(hotReload=True)
        
        logger.info("Auto-reply started. Press Ctrl+C to stop.")
        itchat.run()
        
    except KeyboardInterrupt:
        logger.info("Auto-reply stopped by user")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
