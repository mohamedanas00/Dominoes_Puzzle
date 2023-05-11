package Api;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;


public class GuiScreen {
    ArrayList<Integer> gui;
    JFrame frame = new JFrame();
    int Hlength;
    int Vlength;
    public GuiScreen(ArrayList<Integer> x, int horizontal, int vertical){
        this.gui =x;
        this.Hlength=horizontal;
        this.Vlength=vertical;
        frame.setSize((200*Hlength)+10,(200*Vlength)+10);
        frame.setLayout(new GridLayout(Vlength,Hlength,2,2));
        createScreen();
    }
    void createScreen(){
        JLabel[] screen =new JLabel[gui.size()];
        for(int i = 0; i< gui.size(); i++){
            if(gui.get(i)==1)
                screen[i]=getBox("Fadya.jpg");
            else if (gui.get(i)==6){
                screen[i]=getBox("nos_shmal.jpg");
                screen[i + 1]=getBox("nos_ymeen.png");
                gui.set(i,-1);
                gui.set(i+1,-1);
            }else if(gui.get(i)==0){
                screen[i]=getBox("Boomba.jpg");
            }else if(gui.get(i)==2){
                screen[i]=getBox("fo2_wa2f.jpg");
                screen[i+Hlength]=getBox("t7t_wa2f.jpg");
                gui.set(i,-1);
                gui.set(i+Hlength,-1);
            }
        }
        for(JLabel j1 : screen) {
            frame.add(j1);
        }
            frame.setVisible(true);
            try{
                Thread.sleep(5000);}
            catch (InterruptedException e){
                throw new RuntimeException(e);

            }
            frame.setVisible(false);
        }

    JLabel getBox(String path) {

        ImageIcon imageIcon = new ImageIcon(path);
        JLabel jLabel = new JLabel("", imageIcon, JLabel.CENTER);
        Image image = imageIcon.getImage().getScaledInstance(200, 200, Image.SCALE_DEFAULT);
        ImageIcon imageIcon2 = new ImageIcon(image);
        return new JLabel("", new ImageIcon(image), JLabel.CENTER);
    }
}
