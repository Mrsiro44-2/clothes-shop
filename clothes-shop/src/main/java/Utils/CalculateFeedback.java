/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package Utils;

import Model.Feedback;
import java.util.List;

/**
 *
 * @author HP
 */
public class CalculateFeedback {
    public int totalStar(List<Feedback> feedbacks) {
        if(feedbacks.size() == 0) return 0;
        int i = 0;
        int sumStar = 0;
        for (Feedback f : feedbacks) {
            if(f.getStatus() == 1) {
                sumStar += f.getStar();
            }
        }
        int startTotal = Math.round((float)Math.ceil(sumStar / feedbacks.size()));
       
        return startTotal > 5 ? 5 : startTotal;
    }
}
